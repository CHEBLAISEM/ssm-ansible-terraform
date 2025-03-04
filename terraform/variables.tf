# terraform/variables.tf

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ssm-demo"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "webapp_instance_type" {
  description = "Instance type for webapp instances"
  type        = string
  default     = "t3.micro"
}

variable "bastion_ami" {
  description = "AMI for bastion host"
  type        = string
  default     = "ami-0261755bbcb8c4a84" # Amazon Linux 2023
}

variable "webapp_ami" {
  description = "AMI for webapp instances"
  type        = string
  default     = "ami-0261755bbcb8c4a84" # Amazon Linux 2023
}

variable "key_name" {
  description = "SSH key name"
  type        = string
  default     = "ssm-demo-key"
}

variable "instance_count" {
  description = "Number of webapp instances"
  type        = number
  default     = 2
}