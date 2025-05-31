output "app_server_id" {
  description = "App Server EC2 ID"
  value = aws_instance.app_server.id
}

output "app_server_subnet_id" {
  description = "App Server EC2 Subnet ID"
  value = aws_instance.app_server.subnet_id
}

output "app_server_sg_id" {
  description = "App Server Security Group ID"
  value = aws_security_group.app_server.id
}

