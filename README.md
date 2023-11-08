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
* `sh deploy.sh` to deploy
    * If you are re-running, just type `y` when prompted to overwrite existing ssh keys
* go to displayed url (last line of output)
* `terraform destroy` when finished (will prompt for confirmation)

### Github Actions CICD
Plan workflow triggered on pull request creation on `master` branch and `terraform` folder. Runs terraform init, validate, plan, and will modify PR with comment that includes plan output.  
Apply workflow triggered on merge to `master` branch and `terraform` folder. Runst terraform init, validate, plan, apply and will also configure remote instances.

### Limitations and Next Steps
Limitations:
* Terraform state file is not stored ideally (should be in a remote S3 bucket)
    * Didn't get to that, oh well
* Am using shell scripts and SSH for configuration management (should ideally use SaltStack, Ansible Playbooks, etc.)
    * Didn't get to that, oh well
* Website looks very simple
* SSH keys are actually generated and used on Github Runners by Apply workflow. Not very safe.  

Next Steps:
* Fix configuration management (use tool listed above or custom AMI, which can be shared to AWS accounts or made public)
* MAke a frontend for the website?
* Fix duplicate keypair issue, since the same keypair is created repeatedly (force users to change keypair name to something unique each time?)
* Better yet, remove dependence on SSH keys altogether

