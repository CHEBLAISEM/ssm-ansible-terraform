# terraform/modules/ec2/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
}

variable "webapp_instance_type" {
  description = "Instance type for webapp instances"
  type        = string
}

variable "bastion_ami" {
  description = "AMI for bastion host"
  type        = string
}

variable "webapp_ami" {
  description = "AMI for webapp instances"
  type        = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "instance_count" {
  description = "Number of webapp instances"
  type        = number
  default     = 2
}

variable "ssm_instance_profile" {
  description = "IAM instance profile for SSM"
  type        = string
}

variable "bastion_instance_profile" {
  description = "IAM instance profile for bastion host"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "bastion_security_group_id" {
  description = "Security group ID for bastion host"
  type        = string
}

variable "webapp_security_group_id" {
  description = "Security group ID for webapp instances"
  type        = string
}