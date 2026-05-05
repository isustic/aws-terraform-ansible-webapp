variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name used to tag and identify project resources."
  type        = string
  default     = "aws-terraform-ansible-webapp"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance. Use your public IP with /32"
  type        = string
}