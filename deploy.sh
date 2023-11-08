#!/bin/sh
# Generate SSH keys for connecting to EC2 instances
ssh-keygen -t rsa -b 4096 -f ./flipp-key -q -N ""
chmod 400 flipp-key

# Deploy infrastructure 
terraform init
terraform plan
terraform apply -auto-approve