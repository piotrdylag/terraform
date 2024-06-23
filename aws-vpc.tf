terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_internet_gateway" "lab-igw" {
  vpc_id = aws_vpc.lab-networkpitu-vpc.id
  tags = {
    Environment = "LAB"
    Name = "lab-igw"
  }
}

resource "aws_vpc" "lab-networkpitu-vpc" {
  cidr_block = "10.77.13.0/24"
  tags = {
    Environment = "LAB"
    Name = "lab-networkpitu-vpc"
  }
}

