variable "ec2_type" {
    type        = string
    description = "Type of EC2 instance"
    default     = "t2.micro"
}

variable "aws_region" {
    type        = string
    description = "AWS region to use"
    default     = "us-east-2"
}