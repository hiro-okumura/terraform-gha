# -----------------------------------
# Inputs from Parent Module
# -----------------------------------
variable "common_tags" {
  description = "Project and environment tags"
  type = object({
    project     = string
    environment = string
  })
}

# -----------------------------------
# Inputs from other module outputs
# -----------------------------------
variable "vpc_id" {
  description = "VPC ID from vpc module output"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs from vpc module output"
  type = list(string)
}

variable "app_server_id" {
  description = "App Server EC2 ID from ec2 module output"
  type = string
}

variable "app_server_sg_id" {
  description = "App Server Security Group ID from ec2 module output"
  type = string
}

