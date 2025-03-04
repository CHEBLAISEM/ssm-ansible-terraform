# terraform/outputs.tf

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "bastion_public_ip" {
  value = module.ec2.bastion_public_ip
}

output "alb_dns_name" {
  value = module.ec2.alb_dns_name
}

output "webapp_instance_ids" {
  value = module.ec2.webapp_instance_ids
}