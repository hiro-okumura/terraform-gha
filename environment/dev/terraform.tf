# 今回はコード量が少ないためTerraformバージョン、バックエンド、プロバイダーの設定を1つのファイルにまとめています。
# 実際のプロジェクトでは、これらの設定を別々のファイルに分けることが推奨されます。

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3" {
    bucket       = "tfstate-backend-study-577638386696"
    key          = "terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

  default_tags {
    tags = {
      Name        = "${var.project}-${var.environment}"
      Environment = var.environment
      Project     = var.project
    }
  }
}

