variable "vpc_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "subnets" {
  type = list(string)
}