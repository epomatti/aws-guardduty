terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

data "aws_guardduty_detector" "current" {}

locals {
  guardduty_detector_id = data.aws_guardduty_detector.current.id
}

module "vpc" {
  source = "./modules/vpc"
  region = var.aws_region
}

module "ec2-instance" {
  source        = "./modules/ec2-instance"
  vpc_id        = module.vpc.vpc_id
  az            = module.vpc.primary_availability_zone
  subnet        = module.vpc.primary_subnet_id
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = var.user_data

  depends_on = [module.vpce]
}

module "ipset" {
  source                = "./modules/ipset"
  guardduty_detector_id = local.guardduty_detector_id
}

module "s3" {
  count  = var.create_s3 == true ? 1 : 0
  source = "./modules/s3"
}

module "rds" {
  count                     = var.create_rds == true ? 1 : 0
  source                    = "./modules/rds"
  rds_instance_class        = var.rds_instance_class
  engine_version            = var.rds_engine_version
  vpc_id                    = module.vpc.vpc_id
  primary_availability_zone = module.vpc.primary_availability_zone
  availability_zones        = module.vpc.availability_zones
  subnets                   = module.vpc.subnets
}

module "vpce" {
  source    = "./modules/vpce"
  region    = var.aws_region
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.primary_subnet_id
}
