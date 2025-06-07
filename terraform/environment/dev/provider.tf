provider "aws" {
  # ローカルとCI環境で異なる値を渡す
  profile = var.aws_profile != "" ? var.aws_profile : null
  region  = var.aws_region

  default_tags {
    tags = {
      Environment = var.common_tags.environment
      Project     = var.common_tags.project
    }
  }
}