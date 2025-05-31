output "app_server_id" {
  description = "EC2 ID"
  value = aws_instance.app_server.id
}

output "app_server_subnet_id" {
  description = "EC2 Subnet ID"
  value = aws_instance.app_server.subnet_id
}

output "app_server_sg_id" {
  description = "EC2 Security Group ID"
  value = aws_security_group.app_server.id
}

