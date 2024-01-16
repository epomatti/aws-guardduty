variable "region" {
  type    = string
  default = "us-east-2"
}

variable "primary_availability_zone" {
  type    = string
  default = "us-east-2a"
}

variable "create_rds" {
  type = bool
}
