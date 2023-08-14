output "vpc_id" {
  value = aws_vpc.main.id
}

output "az1" {
  value = local.az1
}

output "az2" {
  value = local.az2
}

output "subnets" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}
