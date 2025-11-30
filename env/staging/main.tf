terraform {
  required_version = ">= 1.0.0"
}

locals {
  env_name = "staging"
}

module "networking" {
  source = "../../modules/networking"

  env_name            = local.env_name
  vpc_cidr            = "10.200.0.0/16"
  public_subnet_cidrs = {
    "us-east-1a" = "10.200.1.0/24"
    "us-east-1b" = "10.200.2.0/24"
    "us-east-1c" = "10.200.3.0/24"
  }
  private_subnet_cidrs = {
    "us-east-1a" = "10.200.11.0/24"
    "us-east-1b" = "10.200.12.0/24"
    "us-east-1c" = "10.200.13.0/24"
  }
}

# security, iam, alb tương tự dev, chỉ đổi env_name = local.env_name

module "security" {
  source  = "../../modules/security"
  env_name = local.env_name
  vpc_id   = module.networking.vpc_id
}

module "iam" {
  source   = "../../modules/iam"
  env_name = local.env_name
}

module "alb" {
  source           = "../../modules/alb"
  env_name         = local.env_name
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id        = module.security.alb_sg_id
  vpc_id           = module.networking.vpc_id
}

module "launch_template" {
  source = "../../modules/launch-template"

  env_name              = local.env_name
  ami_id                = var.ami_id
  instance_type         = "t3.small"
  web_sg_id             = module.security.web_sg_id
  key_name              = var.key_name
  bucket_name           = "group8-staging-web-bucket"
  instance_profile_name = module.iam.instance_profile_name
}

module "asg" {
  source = "../../modules/asg"

  env_name           = local.env_name
  min_size           = 1
  max_size           = 4
  desired_capacity   = 3
  launch_template_id = module.launch_template.launch_template_id
  private_subnet_ids = module.networking.private_subnet_ids
  target_group_arn   = module.alb.target_group_arn
}
