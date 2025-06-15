module "vpc" {
  source = "../../modules/vpc"

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  vpc_cidr_block  = var.vpc_cidr_block
  common_tags     = var.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  ssh_cidr_blocks = var.ssh_cidr_blocks
  instance_type   = var.instance_type
  ami             = var.ami
  key_name        = var.key_name
  common_tags     = var.common_tags

  vpc_id = module.vpc.vpc_id

  iam_instance_profile = module.s3.s3_access_instance_profile_name

  alb_target_group_arn = module.alb.alb_target_group_arn
  public_subnet_ids    = [module.vpc.public_subnet_id_map["public1"], module.vpc.public_subnet_id_map["public2"]]
}

module "alb" {
  source = "../../modules/alb"

  common_tags = var.common_tags

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = values(module.vpc.public_subnet_id_map)
  app_server_sg_id  = module.ec2.app_sg_id
}

module "rds" {
  source = "../../modules/rds"

  common_tags = var.common_tags

  vpc_id        = module.vpc.vpc_id
  app_subnet_id = module.ec2.app_subnet_ids[0]
  app_sg_id     = module.ec2.app_sg_id
  private_subnet_ids = [
    module.vpc.private_subnet_id_map["private1"],
    module.vpc.private_subnet_id_map["private2"]
  ]
}

module "s3" {
  source = "../../modules/s3"

  common_tags = var.common_tags
}