terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "ec2_ssh_keys" {
  key_name    = "flipp-keypair"
  public_key  = file("./flipp-key.pub")
}

# Setting up the EC2 instace named as flipp-takehome
resource "aws_instance" "flipp-takehome" {
  ami             = "ami-089c26792dcb1fbd4"
  instance_type   = var.ec2_type
  key_name        = aws_key_pair.ec2_ssh_keys.key_name
  security_groups = ["launch-wizard-2"]
}