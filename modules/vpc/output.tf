output "vpc_id" {
  value = aws_vpc.main.id
}

output "availability_zones" {
  value = local.availability_zones
}

output "subnets" {
  value = local.subnets
}

output "primary_availability_zone" {
  value = local.availability_zones[0]
}

output "primary_subnet_id" {
  value = local.subnets[0]
}
