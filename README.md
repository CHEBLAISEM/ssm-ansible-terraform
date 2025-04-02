# 🔧 SSM Ansible Terraform Project (Dev Environment)

This project demonstrates how to use **Terraform** and **Ansible** to provision and configure AWS infrastructure, using **AWS Systems Manager (SSM)** for agentless connections (no SSH). It was implemented in a **Development Environment** for practice and skill building.

---

## 🛠️ Tools & Technologies

- **Terraform**: Infrastructure as Code  
- **Ansible**: Configuration Management  
- **AWS SSM**: Remote EC2 management without SSH  
- **S3**: Used for Ansible over SSM  
- **EC2, ALB, IAM, VPC, and Security Groups**

---

## ✅ What I Did

- Cloned and practiced the project from [zsoftly/ssm-ansible-terraform](https://github.com/zsoftly/ssm-ansible-terraform)
- Set it up inside WSL Ubuntu + VS Code
- Used `terraform apply` to provision:
  - VPC, EC2 instances, Application Load Balancer, IAM Roles
- Used **Ansible** via **AWS SSM** (no SSH required)
- Deployed a demo Apache web app using Jinja2 templating
- Solved issues like IAM permissions, missing variables, and SSM connection setup
- Validated deployment via public ALB URL and SSM session
- Cleaned up all AWS resources using `terraform destroy`

---

## 📦 Project Structure

. ├── terraform/ # All Terraform code (infrastructure) 
├── ansible/ # All Ansible playbooks, inventory, roles 
├── screenshots/ # Optional: Add screenshots of CLI, ALB URL, or webapp output 
└── README.md # This file


---

## 🧹 Cleanup

All infrastructure has been **destroyed** using `terraform destroy` to avoid AWS billing charges.

---

## 📅 Date

Practice Completed on: **April 02, 2025**

---

## 🤝 Credit

Original project by [zsoftly](https://github.com/zsoftly/ssm-ansible-terraform)  
Implemented in a **dev environment** by **CheBM**
