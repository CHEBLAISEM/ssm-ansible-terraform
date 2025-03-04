#!/bin/bash
# Get S3 bucket name from Terraform output
BUCKET_NAME=$(cd terraform && terraform output -raw ansible_ssm_bucket_name)

# Update ansible.cfg
cat > ansible.cfg << EOF
[defaults]
inventory = ansible/inventory/hosts.yml
host_key_checking = False

[aws_ssm_plugin]
bucket_name = ${BUCKET_NAME}
EOF

echo "Ansible configured with SSM bucket: ${BUCKET_NAME}"