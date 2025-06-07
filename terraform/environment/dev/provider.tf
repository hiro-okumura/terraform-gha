provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.common_tags.environment
      Project     = var.common_tags.project
    }
  }
}