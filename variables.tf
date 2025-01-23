variable "aws_region" {
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

variable "rds_instance_class" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "user_data" {
  type = string
}
