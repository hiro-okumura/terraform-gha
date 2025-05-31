# -----------------------------------
# Inputs from Parent Module
# -----------------------------------
variable "db_username" {
  description = "Username in AWS Secrets Manager for rds access"
  type        = string
}

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
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs from vpc module output"
  type        = list(string)
}

variable "ec2_subnet_id" {
  description = "EC2 Subnet ID  from ec2 module output"
  type        = string
}

variable "ec2_sg_id" {
  description = "EC2 Security Group ID from ec2 module output"
  type        = string
}

