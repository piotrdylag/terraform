# Provider AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.11.1.0/24"
  tags = {
    Name = "main-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.11.1.0/26"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "main-rtb"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group (allow HTTP/SSH)
resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In development and production limit to your public IP
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-sg"
  }
}

# EC2 Instance (with pre installed nginx)
resource "aws_instance" "webserver" {
  ami           = "ami-0ed1e06189d76073f"  # Ubuntu 24.04 for eu-central-1
  instance_type = "t4g.small"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.web.name]
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Webserver created successfully!</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "migrated-web-server"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "data" {
  bucket = "my-main-bucket-${random_string.suffix.result}"  # Unique name
  tags = {
    Name = "migration-storage"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}