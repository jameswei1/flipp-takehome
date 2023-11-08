terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
}

resource "aws_key_pair" "ec2_ssh_keys" {
  key_name    = "flipp-keypair"
  public_key  = file("./flipp-key.pub")
}

# Setting up the EC2 instace named as flipp-takehome
resource "aws_instance" "flipp-takehome-test" {
  ami             = "ami-089c26792dcb1fbd4"
  instance_type   = var.ec2_type
  key_name        = aws_key_pair.ec2_ssh_keys.key_name
  security_groups = ["launch-wizard-2"]

  provisioner "remote-exec" {
    inline = [
      "sudo yum install git -y",
      "sudo yum install nginx -y",
      "git clone https://github.com/jameswei1/flipp-takehome.git",
      "sudo mv flipp-takehome/nginx.conf /etc/nginx/nginx.conf -f",
      "sudo systemctl start nginx",
      "sudo yum install nodejs -y",
      "sudo npm install forever -g",
      "cd flipp-takehome",
      "npm install",
      "forever start server.js",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./flipp-key")
      host        = aws_instance.flipp-takehome-test.public_ip
    }
  }
}