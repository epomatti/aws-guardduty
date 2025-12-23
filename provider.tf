provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "guarduty-sandbox"
    }
  }

  ignore_tags {
    key_prefixes = ["QSConfigId"]
  }
}
