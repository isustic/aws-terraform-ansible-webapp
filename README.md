# AWS Terraform Ansible Web App Infrastructure

This project deploys a small production-style web application infrastructure on AWS using Terraform and Ansible.

## Goals

- Provision AWS infrastructure with Terraform
- Configure Linux servers with Ansible
- Deploy a simple web service
- Practice AWS networking, security groups, remote access, and infrastructure automation
- Document architecture, tradeoffs, risks, and production improvements

## Current Status

Initial project setup.

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