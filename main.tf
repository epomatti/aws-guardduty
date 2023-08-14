terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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
