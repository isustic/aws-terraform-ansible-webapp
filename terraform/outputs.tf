output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the created public subnet"
  value       = aws_subnet.public.id
}

output "web_security_group_id" {
  description = "ID of the web server security group."
  value       = aws_security_group.web.id
}

output "web_instance_id" {
  description = "ID of the web EC2 instance."
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IP address of the web EC2 instance."
  value       = aws_instance.web.public_ip
}

output "web_public_dns" {
  description = "Public DNS name of the web EC2 instance."
  value       = aws_instance.web.public_dns
}