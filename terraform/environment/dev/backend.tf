terraform {
  backend "s3" {
    bucket   = "tfstate-backend-study-577638386696"
    key         = "terraform.tfstate"
    region  = "ap-northeast-1"
    use_lockfile = true
  }
}