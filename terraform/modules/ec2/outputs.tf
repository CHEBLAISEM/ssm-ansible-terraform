# terraform/modules/ec2/outputs.tf

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "webapp_instance_ids" {
  value = aws_instance.webapp[*].id
}

output "alb_dns_name" {
  value = aws_lb.webapp.dns_name
}