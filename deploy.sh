#!/bin/sh
# Generate SSH keys for connecting to EC2 instances
ssh-keygen -t rsa -b 4096 -f ./flipp-key -q -N ""
chmod 400 flipp-key

# Deploy infrastructure 
terraform init
terraform plan
terraform apply -auto-approve

echo "[INFO] Waiting for 10 seconds..."
sleep 10

# Connect to deployed servers using ssh
# Install Git, nginx, clone repo
ssh -i flipp-key -o StrictHostKeychecking=no ec2-user@$(terraform output -raw public_ip) "sudo yum install git -y;sudo yum install nginx -y;git clone https://github.com/jameswei1/flipp-takehome.git"
# Move nginx.conf to correct place, overwrite existing (default) conf, start nginx server
ssh -i flipp-key -o StrictHostKeychecking=no ec2-user@$(terraform output -raw public_ip) "sudo mv flipp-takehome/nginx.conf /etc/nginx/nginx.conf -f;sudo systemctl start nginx"
# Install Node, NPM, forever change directory into flipp-takehome and install dependencies, start Node backend server
ssh -i flipp-key -o StrictHostKeychecking=no ec2-user@$(terraform output -raw public_ip) "sudo yum install nodejs -y;sudo npm install forever -g;cd flipp-takehome;npm install;forever start server.js"
