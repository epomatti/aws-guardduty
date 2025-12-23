variable "vpc_id" {
  type = string
}

variable "primary_availability_zone" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "rds_instance_class" {
  type = string
}

variable "engine_version" {
  type = string
}
