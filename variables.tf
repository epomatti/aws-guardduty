variable "aws_region" {
  type = string
}

variable "create_s3" {
  type = bool
}

variable "create_rds" {
  type = bool
}

variable "rds_engine_version" {
  type = string
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
