module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  common_tags     = var.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type = var.instance_type

  vpc_id     = module.vpc.vpc_id
  subnet_id          = module.vpc.public_subnet_id_map["public1"]
  ssh_cidr_blocks    = var.ssh_cidr_blocks


  key_name             = var.key_name
  common_tags          = var.common_tags

}