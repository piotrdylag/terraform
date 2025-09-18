# AWS Migration Terraform Project

A simple Infrastructure as Code (IaC) example demonstrating a basic migration from on-premises to AWS. This project deploys a VPC, an EC2 instance running a web server (Nginx/Apache), and an S3 bucket for storage – simulating a quick cloud migration setup.
Built with Terraform for repeatable, version-controlled deployments.

[![Terraform](https://img.shields.io/badge/terraform-%23736ADC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

## Features
- **VPC Setup**: Private network with public subnet and internet gateway.
- **EC2 Instance**: t2.micro (Free Tier eligible) with auto-installed web server and a "Migration Successful" page.
- **S3 Bucket**: Secure storage for migrated data.
- **Security Group**: Allows HTTP (80) and SSH (22) access.
- **Outputs**: Public IP of EC2 and S3 bucket name for easy access.

## Technologies Used
- **Terraform**: v1.5+ (HashiCorp provider for AWS ~> 5.0)
- **AWS Services**: VPC, EC2, S3, Route Tables, Security Groups
- **Tested On**: AWS Free Tier (eu-west-1 region) – zero cost for demos

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- [AWS CLI](https://aws.amazon.com/cli/) configured (`aws configure` with IAM user credentials)
- AWS Free Tier account
- Git for version control

## Architecture Diagram
Here's the infrastructure created by this Terraform configuration:

![AWS Migration Architecture](https://i.imgur.com/NEzhcUk.png)

## Quick Start
1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/aws-migration-terraform.git
   cd aws-migration-terraform
   ```

2. Initialize Terraform:
    ```bash
    terraform init
    ```

3. Review the plan (dry run):
    ```bash
    terraform plan
    ```
    This shows what resources will be created.

4. Apply the configuration:
    ```bash
    terraform apply
    ```
    Type yes to confirm. Deployment takes ~5-10 minutes.

5. Access the deployed resources:
    - Web Server: Open http://<EC2_PUBLIC_IP> in your browser (output shown after apply).
    - S3 Bucket: Use the bucket name from outputs to upload files via AWS Console or CLI.

