# Flipp Take Home Exercise
### Server Architecture/API Overview
AWS EC2 instance running Nginx Web Server and an Express/Node backend. Requests to the `/api` endpoint are redirected to backend.  
`server.js` contains backend, uses third party API (https://api.ipify.org?format=json) to get host machine's public IP.  
Returns host machine's public IP and current time as formatted plaintext string.
`nginx.conf` contains nginx configuration.

### Infrastructure Automation
Infrastructure deployment automated using Terraform, shell script.  
Can configure AWS region using Terraform variable in `variables.tf`
The shell script `deploy.sh` will:
* generate a ssh-key used for connecting to the new EC2 instance
* deploy infrastructure (EC2, ssh keypair) using Terraform init, plan, apply.
* remotely configure new EC2 instance by remotely executing commands using ssh keys
    * install git, nginx, clone repository, configure and start nginx, install project dependencies, and finally start Node backend server

### Deployment
Clone repo locally, cd into repo, run:
* `chmod +x deploy.sh` to grant execute permissions to deploy script, use sudo if necessary
* set necessary environment variables for AWS access:  
    * export AWS_ACCESS_KEY_ID="your-access-key-id"
    export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
    export AWS_DEFAULT_REGION="your-region”
* `sh deploy.sh` to deploy (will prompt ONCE for confirmation of ssh to unknown host, type `yes`)
* go to displayed url (last line of output)
* `terraform destroy` when finished (will prompt for confirmation)
