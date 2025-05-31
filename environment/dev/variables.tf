# -----------------------------------
# AWS
# -----------------------------------

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

# -----------------------------------
# Tags
# -----------------------------------

variable "common_tags" {
  description = "Project and environment tags"
  type = object({
    project     = string
    environment = string
  })
}
# -----------------------------------
# VPC
# -----------------------------------
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "A map of public subnet names to their configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    public1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-1a"
    }
    public2 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-1c"
    }
  }
}

variable "private_subnets" {
  description = "A map of private subnet names to their configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    private1 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-northeast-1a"
    }
    private2 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "ap-northeast-1c"
    }
  }
}

# -----------------------------------
# EC2
# -----------------------------------
variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "SSH CIDR blocks"
  type        = list(string)
}