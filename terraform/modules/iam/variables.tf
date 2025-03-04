# terraform/modules/iam/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "ssm_bucket_name" {
  description = "Name of the S3 bucket used for Ansible SSM connections"
  type        = string
}