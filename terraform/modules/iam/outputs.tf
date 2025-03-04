# terraform/modules/iam/outputs.tf

output "ssm_instance_profile_name" {
  value = aws_iam_instance_profile.ssm_profile.name
}

output "bastion_instance_profile_name" {
  value = aws_iam_instance_profile.bastion_profile.name
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.ssm_profile.arn
  description = "ARN of the SSM instance profile"
}

output "ssm_role_arn" {
  value = aws_iam_role.ssm_role.arn
}

output "bastion_role_arn" {
  value = aws_iam_role.bastion_role.arn
}