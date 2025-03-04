# terraform/main.tf

provider "aws" {
  region = var.aws_region
}

module "network" {
  source         = "./modules/network"
  vpc_cidr       = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  project_name   = var.project_name
}

module "iam" {
  source      = "./modules/iam"
  project_name = var.project_name
  ssm_bucket_name = aws_s3_bucket.ansible_ssm_bucket.bucket
}

module "ec2" {
  source                = "./modules/ec2"
  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  bastion_instance_type = var.bastion_instance_type
  webapp_instance_type  = var.webapp_instance_type
  bastion_ami           = var.bastion_ami
  webapp_ami            = var.webapp_ami
  key_name              = var.key_name
  instance_count        = var.instance_count
  ssm_instance_profile  = module.iam.ssm_instance_profile_name
  bastion_instance_profile = module.iam.bastion_instance_profile_name
  alb_security_group_id = module.network.alb_security_group_id
  bastion_security_group_id = module.network.bastion_security_group_id
  webapp_security_group_id = module.network.webapp_security_group_id
}

# Create an output file for Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/hosts.yml.tpl", {
    bastion_ip = module.ec2.bastion_public_ip,
    webapp_instances = module.ec2.webapp_instance_ids
    bucket_name = aws_s3_bucket.ansible_ssm_bucket.bucket
  })
  filename = "../ansible/inventory/hosts.yml"
}

resource "aws_s3_bucket" "ansible_ssm_bucket" {
  bucket = "ansible-ssm-bucket-${random_string.suffix.result}"  # Use a unique name here
  force_destroy = true  # Optional: allows Terraform to delete the bucket even if it contains objects
  
  tags = {
    Name = "Ansible SSM Bucket"
    Purpose = "Used by Ansible SSM connection plugin"
  }
}

# Generate a random suffix to ensure bucket name uniqueness
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Add proper bucket policy if needed
resource "aws_s3_bucket_policy" "ansible_ssm_bucket_policy" {
  bucket = aws_s3_bucket.ansible_ssm_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = "${aws_s3_bucket.ansible_ssm_bucket.arn}/*"
        Principal = {
          AWS = [
            module.iam.ssm_role_arn,    # Reference IAM role ARN for SSM access
            module.iam.bastion_role_arn  # Reference IAM role ARN for Bastion access
          ]
        }
      }
    ]
  })
}

# Add this bucket name to your outputs
output "ansible_ssm_bucket_name" {
  value = aws_s3_bucket.ansible_ssm_bucket.bucket
  description = "Name of the S3 bucket used for Ansible SSM connections"
}