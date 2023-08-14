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
  source            = "./modules/rds"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.primary_availability_zone
  subnets           = module.vpc.subnets
}
