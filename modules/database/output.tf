output "address" {
  value = aws_db_instance.default.address
}

output "username" {
  value = aws_db_instance.default.username
}

output "password" {
  value     = aws_db_instance.default.password
  sensitive = true
}

output "db_name" {
  value     = aws_db_instance.default.db_name
  sensitive = true
}

output "rds_arn" {
  value = aws_db_instance.default.arn
}

output "rds_instance_identifier" {
  value = aws_db_instance.default.identifier
}
