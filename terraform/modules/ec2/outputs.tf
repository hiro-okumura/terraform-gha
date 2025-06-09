# output "app_server_id" {
#   description = "App Server EC2 ID"
#   value       = aws_autoscaling_group.app_server.id
# }

output "app_subnet_ids" {
  description = "App EC2 Subnet IDs"
  value       = tolist(aws_autoscaling_group.app.vpc_zone_identifier)
}

output "app_sg_id" {
  description = "App Security Group ID"
  value       = aws_security_group.app.id
}
