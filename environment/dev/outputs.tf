output "url" {
  description = "URL of the ALB DNS"
  value = "http://${module.alb.dns_name}"
}