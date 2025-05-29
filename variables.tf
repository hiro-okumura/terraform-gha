variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment tag for resources"
  type        = string
}

variable "project" {
  description = "Project tag for resources"
  type        = string
}