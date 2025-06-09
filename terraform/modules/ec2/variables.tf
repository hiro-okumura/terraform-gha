# -----------------------------------
# Inputs from Parent Module
# -----------------------------------
variable "ssh_cidr_blocks" {
  description = "List of SSH CIDR blocks"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "EC2 AMI ID"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name to enable SSH access"
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

variable "iam_instance_profile" {
  description = "s3 access instance profile name from s3 module output"
  type        = string
}

variable "public_subnet_ids" {
  description = "Subnet ID from vpc module output"
  type        = list(string)
}


variable "alb_target_group_arn" {
  description = "ALB target group ARN from alb module output"
  type        = string
}
