variable "common_tags" {
  description = "Project and environment tags"
  type = object({
    project     = string
    environment = string
  })
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "key_name" {
  description = "Key name"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "SSH CIDR blocks"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type        = string
}
