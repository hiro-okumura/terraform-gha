variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "A map of public subnet names to their configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "A map of private subnet names to their configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
