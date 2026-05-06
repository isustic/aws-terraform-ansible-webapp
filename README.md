# AWS Terraform Ansible Web App Infrastructure

This project deploys a small production-style web application infrastructure on AWS using Terraform and Ansible.

## Goals

- Provision AWS infrastructure with Terraform
- Configure Linux servers with Ansible
- Deploy a simple web service
- Practice AWS networking, security groups, remote access, and infrastructure automation
- Document architecture, tradeoffs, risks, and production improvements

## Current Status

Working V1 infrastructure is in place.

- Terraform provisions the AWS network, security group, and EC2 web server.
- Ansible connects to the EC2 instance and configures Nginx.
- The custom web page is deployed to the server.
- Terraform validation is covered by GitHub Actions.
- Ansible syntax validation is documented as part of the project workflow.

## Planned Architecture

Internet → EC2 instance → Nginx / Docker-based web service

## Tools

- AWS
- Terraform
- Ansible
- Linux
- Nginx
- Docker
- GitHub Actions

## Current Architecture - V1

Internet traffic reaches a public EC2 instance running Nginx.

```text
Internet
   |
Public IP / DNS
   |
AWS Security Group
   |-- HTTP 80 from 0.0.0.0/0
   |-- SSH 22 from trusted public IP only
   |
Ubuntu EC2 instance
   |
Nginx
```

## Ansible Configuration

Ansible is used to configure the EC2 web server after Terraform provisions the infrastructure.

Current playbook tasks:

- Updates the apt package cache
- Installs Nginx
- Ensures Nginx is enabled and running
- Deploys a custom `index.html` page

The playbook is idempotent. After the first successful configuration run, repeated runs complete with `changed=0`.

## Current Validation

- Terraform successfully provisions AWS networking, security group, and EC2 resources.
- Ansible successfully connects to the instance over SSH.
- Nginx is installed, enabled, and running.
- A custom web page is reachable over HTTP.

## Inventory Generation

The Ansible inventory is generated from Terraform output using:

```bash
./scripts/generate_inventory.sh
```

## CI Validation

This project uses GitHub Actions for safe infrastructure and configuration validation.

### Terraform Check

Runs automatically on changes to Terraform files and can also be triggered manually.

Checks:

- `terraform fmt -check -recursive`
- `terraform init`
- `terraform validate`

### Ansible Check

Runs automatically on changes to Ansible files and can also be triggered manually.

Checks:

- `ansible-playbook -i ansible/inventory.ini.example --syntax-check ansible/playbook.yml`

The workflows are intentionally non-destructive. They do not run `terraform apply`, do not connect to AWS resources, and do not require cloud credentials or SSH private keys in GitHub.

## Architecture Explanation

This project uses Terraform to provision AWS infrastructure and Ansible to configure the EC2 instance after provisioning.

Terraform creates the VPC, public subnet, internet gateway, route table, security group, and EC2 instance. The subnet is public because its route table sends `0.0.0.0/0` traffic to the Internet Gateway. The EC2 instance receives a public IP and is reachable over HTTP because the security group allows inbound TCP traffic on port 80 from `0.0.0.0/0`.

SSH access is restricted to a trusted public IP using a `/32` CIDR block. This allows administrative access from one known IP address instead of exposing SSH to the entire internet.

Ansible connects to the EC2 instance over SSH using an inventory generated from Terraform output. The playbook installs Nginx, ensures the service is enabled and running, and deploys a custom `index.html` page.

GitHub Actions validates the Terraform and Ansible code without applying infrastructure changes or requiring cloud credentials.

## Known Limitations

- The EC2 instance is public and directly reachable from the internet.
- SSH is exposed on port 22, although restricted to a trusted `/32` public IP.
- Terraform state is currently local, not stored remotely.
- The project does not currently use HTTPS.
- There is no DNS record or custom domain.
- There is no monitoring, alerting, or centralized logging.
- There is no load balancer or high availability.
- The application is currently a static Nginx page, not a containerized service.

## Production Improvements

For a more production-ready version, I would add:

- Remote Terraform state using S3 with DynamoDB state locking.
- Private subnets for application instances.
- An Application Load Balancer as the public entry point.
- HTTPS using ACM certificates.
- Route 53 DNS records.
- AWS Systems Manager Session Manager instead of public SSH.
- CloudWatch alarms for instance health, CPU, disk, and service availability.
- Docker-based application deployment.
- CI/CD plan validation with approval gates before apply.

## Cost Control

This project is designed to stay low-cost for learning:

- Uses a small `t3.micro` EC2 instance.
- Avoids NAT Gateway in the initial version.
- Does not use RDS, Load Balancer, or paid managed services in v1.
- Infrastructure can be destroyed with:

```bash
cd terraform
terraform destroy
```

Docker is also installed and managed by Ansible. The playbook ensures Docker is present, enabled, running, and that the `ubuntu` user is added to the `docker` group for non-root container management.

## Docker Container Validation

Docker is installed and managed by Ansible. The playbook also runs a test `nginx:alpine` container named `test-nginx`.

The container maps host port `8080` to container port `80`:

```text
EC2 host port 8080 → container port 80
```

