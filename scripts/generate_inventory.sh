#!/usr/bin/env bash
set -euo pipefail

WEB_IP=$(cd terraform && terraform output -raw web_public_ip)

cat > ansible/inventory.ini <<EOF
[web]
${WEB_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/pixel-tracker-key.pem ansible_python_interpreter=/usr/bin/python3
EOF

echo "Generated Ansible inventory for web host: ${WEB_IP}"
