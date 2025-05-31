variable "common_tags" {
  description = "Project and environment tags"
  type = object({
    project     = string
    environment = string
  })
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "app_server_id" {
  description = "EC2 ID"
  type = string
}

variable "app_server_sg_id" {
  description = "EC2 Security Group ID"
  type = string
}

