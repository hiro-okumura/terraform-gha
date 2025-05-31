output "app_server_sg_id" {
  value = aws_security_group.app_server.id
}

output "ec2_subnet_id" {
  value = aws_instance.app_server.subnet_id
}