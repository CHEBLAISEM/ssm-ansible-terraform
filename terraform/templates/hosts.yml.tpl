# terraform/templates/hosts.yml.tpl

all:
  vars:
    ansible_connection: community.aws.aws_ssm
    ansible_aws_ssm_bucket_name: ${bucket_name}
  children:
    bastion:
      hosts:
        bastion:
          ansible_host: ${bastion_ip}
          ansible_user: ec2-user
    webapp:
      hosts:
%{ for instance_id in webapp_instances ~}
        ${instance_id}:
          ansible_connection: aws_ssm
          ansible_aws_ssm_instance_id: ${instance_id}
          ansible_aws_ssm_region: us-east-1
%{ endfor ~}