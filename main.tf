terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_guardduty_detector" "main" {
  enable = true
}

module "s3" {
  source = "./modules/s3"
}

module "vpc" {
  source = "./modules/vpc"
  region = var.region
}

module "rds" {
  count   = var.create_rds == true ? 1 : 0
  source  = "./modules/rds"
  vpc_id  = module.vpc.vpc_id
  azs     = module.vpc.azs
  subnets = module.vpc.subnets
}

module "ec2-instance" {
  source = "./modules/ec2-instance"
  vpc_id = module.vpc.vpc_id
  az     = var.primary_availability_zone
  subnet = module.vpc.subnets[0]
}

module "vpce" {
  source    = "./modules/vpce"
  region    = var.region
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnets[0]
}

module "ipset" {
  source                = "./modules/ipset"
  guardduty_detector_id = aws_guardduty_detector.main.id
}
