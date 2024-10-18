terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41"
    }

    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
  backend "s3" {
    bucket = "tfpocbucket001"
    key    = "docker-swarm/terraform.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = local.region
}

locals {
  region        = "eu-north-1"
  workers_count = 2
  tags = {
    infra = "kubernetes_cluster"
  }
}

# RSA KEY PAIR
resource "tls_private_key" "foo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "foo" {
  key_name   = "id_rsa"
  public_key = tls_private_key.foo.public_key_openssh
}

output "ssh_key" {
  value     = tls_private_key.foo.private_key_pem
  sensitive = true
}

# Security group
resource "aws_security_group" "master_sg" {
  name        = "master_sg"
  description = "Security group for EC2 instances"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
resource "aws_instance" "master" {
  count         = 1
  ami           = "ami-08eb150f611ca277f"
  instance_type = "t3.small"
  security_groups = [aws_security_group.master_sg.name]
  key_name = aws_key_pair.foo.key_name

  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "worker" {
  count         = 2
  ami           = "ami-08eb150f611ca277f"
  instance_type = "t3.small"
  security_groups = [aws_security_group.master_sg.name]
  key_name = aws_key_pair.foo.key_name

  tags = {
    Name = "Worker-"
  }
}