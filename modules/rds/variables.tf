variable "vpc_id" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "rds_instance_class" {
  type = string
}
