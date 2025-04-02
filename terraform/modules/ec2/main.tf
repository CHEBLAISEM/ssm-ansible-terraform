# terraform/modules/ec2/main.tf

# Bastion host
resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.bastion_security_group_id]
  key_name                    = var.key_name
  iam_instance_profile        = var.bastion_instance_profile


  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3 python3-pip
    pip3 install ansible boto3 botocore

    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
    
    # Create ansible.cfg
    mkdir -p /home/ec2-user/.ansible
    cat > /home/ec2-user/.ansible.cfg <<'EOT'
    [defaults]
    host_key_checking = False
    remote_user = ec2-user
    
    [inventory]
    enable_plugins = aws_ec2
    EOT
    
    chown -R ec2-user:ec2-user /home/ec2-user/.ansible*
  EOF

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

# Web app instances
resource "aws_instance" "webapp" {
  count                  = var.instance_count
  ami                    = var.webapp_ami
  instance_type          = var.webapp_instance_type
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.webapp_security_group_id]
  iam_instance_profile   = var.ssm_instance_profile

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
  EOF

  tags = {
    Name = "${var.project_name}-webapp-${count.index}"
  }
}

# Application Load Balancer
resource "aws_lb" "webapp" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "webapp" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

resource "aws_lb_listener" "webapp" {
  load_balancer_arn = aws_lb.webapp.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp.arn
  }
}

resource "aws_lb_target_group_attachment" "webapp" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.webapp.arn
  target_id        = aws_instance.webapp[count.index].id
  port             = 80
}