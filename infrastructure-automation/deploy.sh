#!/bin/sh
# Generate SSH keys for connecting to EC2 instances
ssh-keygen -t rsa -b 4096 -f ./flipp-key -q -N ""
chmod 400 flipp-key

# Deploy infrastructure 
terraform init
terraform plan
terraform apply -auto-approve

# Connect to deployed servers using ssh
# Install Git, nginx, clone repo
ssh -i flipp-key ec2-user@$(terraform output -raw public_ip) "sudo yum install git -y;sudo yum install nginx -y;git clone https://github.com/jameswei1/flipp-takehome.git"
# Move nginx.conf to correct place, overwrite existing (default) conf, start nginx server
ssh -i flipp-key ec2-user@$(terraform output -raw public_ip) "sudo mv flipp-takehome/nginx.conf /etc/nginx/nginx.conf -f;sudo systemctl start nginx"
# Install Node, NPM, change directory into flipp-takehome and install dependencies, start Node backend server
ssh -i flipp-key ec2-user@$(terraform output -raw public_ip) "sudo yum install nodejs -y;cd flipp-takehome;npm install;node server.js"
