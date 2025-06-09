output "dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_target_group_arn" {
  description = "ALB target group ARN"
  value       = aws_lb_target_group.app.arn
}