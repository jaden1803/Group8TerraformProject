# Group 8 – Final Project: Tier Two Infrastructure (Terraform)

This repository contains the complete Infrastructure-as-Code (IaC) setup for **Group 8** in the ACS730 Final Project.

The goal is to provision a **highly available two-tier static web application** on AWS using **Terraform**, following:

- Multi-environment separation (**dev, staging, prod**)
- Modular Terraform design
- Load Balancer + Auto Scaling Group for high availability
- IAM instance role + S3 for static content
- GitHub Actions for basic security scanning

---

## 🌎 Project Architecture (High Level)

For each environment (dev, staging, prod), the infrastructure includes:

- **VPC** with `/16` CIDR
  - Dev: `10.100.0.0/16`
  - Staging: `10.200.0.0/16`
  - Prod: `10.250.0.0/16`
- **3 public subnets** (one per AZ)
- **3 private subnets** (one per AZ)
- **Internet Gateway** attached to the VPC
- **NAT Gateway** in a public subnet for outgoing internet access from private subnets
- **Application Load Balancer (ALB)** in public subnets
- **Auto Scaling Group (ASG)** of EC2 instances in private subnets
- **Launch Template** with user data:
  - Installs Apache (`httpd`) and AWS CLI
  - Downloads `index.html` from a private S3 bucket
- **Security Groups**
  - ALB SG: allow HTTP (80) from the internet
  - Web SG: allow HTTP (80) only from ALB SG
- **S3 buckets** (per environment)
  - Store Terraform remote state
  - Store static web content (HTML + images)
- **IAM Role & Instance Profile**
  - Attached to EC2 instances
  - Grants read-only access to the content S3 bucket

---

## 🧩 Environments

We maintain **three** isolated Terraform environments under the `env/` folder.

### Development (`env/dev`)

- VPC CIDR: `10.100.0.0/16`
- Instance type: `t3.micro`
- Auto Scaling:
  - `min_size = 1`
  - `desired_capacity = 2`
  - `max_size = 4`
- Used for initial testing and debugging
- Safe to break and fix quickly

### Staging (`env/staging`)

- VPC CIDR: `10.200.0.0/16`
- Instance type: `t3.small`
- Auto Scaling:
  - `min_size = 2`
  - `desired_capacity = 3`
  - `max_size = 4`
- Close replica of production
- Cost-optimized
- Used as **Green environment** for pre-production testing

### Production (`env/prod`)

- VPC CIDR: `10.250.0.0/16`
- Instance type: `t3.medium`
- Auto Scaling:
  - `min_size = 2`
  - `desired_capacity = 3`
  - `max_size = 4`
- Live-like environment
- Used to demonstrate high availability and failover scenarios

---

## 📁 Repository Structure

```bash
.
├── env
│   ├── dev
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── staging
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── prod
│       ├── backend.tf
│       ├── main.tf
│       ├── provider.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── modules
│   ├── networking
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── iam
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── launch-template
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── user_data.sh
│   ├── alb
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── asg
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── .github
│   └── workflows
│       └── security.yml
│
├── provider.tf
└── README.md
## Environment Deployment Guide

This repository deploys a highly available two-tier web application on AWS using Terraform.

### Environments

We manage three separate environments:

- **dev** – used for initial changes and testing.
- **staging** – used to test a near-production copy of the stack.
- **prod** – final production environment.

Each environment has its own Terraform state stored in S3.

| Environment | State bucket name                         |
|------------|-------------------------------------------|
| dev        | `group8-dev-tfstate-bucket`               |
| staging    | `group8-staging-tfstate-bucket`           |
| prod       | `group8-prod-tfstate-bucket` *(planned)*  |

> Note: In our lab account we do **not** have permission to create IAM roles.  
> Because of this, EC2 instances run **without** an instance profile and cannot read from S3 directly.
> Static content is served from the EC2 web server filesystem instead of using an S3 origin.

### How to deploy an environment

From the project root:

```bash
cd env/<env-name>   # dev, staging, or prod

terraform init
terraform validate
terraform plan -out <env-name>.plan
terraform apply <env-name>.plan
