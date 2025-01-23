resource "aws_db_instance" "default" {
  identifier = "rds-guardduty"

  db_name        = "guarddutydb"
  engine         = "postgres"
  engine_version = "16.3"

  username = "postgres"
  password = "postgres"

  # Network
  db_subnet_group_name = aws_db_subnet_group.default.name
  # availability_zone    = var.availability_zone
  publicly_accessible = false

  # Resources
  instance_class    = var.rds_instance_class
  allocated_storage = 30
  storage_type      = "gp3"

  # Security
  storage_encrypted      = true
  vpc_security_group_ids = [aws_security_group.allow_postgresql.id]

  # Multi-AZ
  multi_az = false

  # Upgrades
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true

  blue_green_update {
    enabled = false
  }

  # Protect
  deletion_protection      = false
  skip_final_snapshot      = true
  delete_automated_backups = true
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-guardduty"
  subnet_ids = var.subnets
}

resource "aws_security_group" "allow_postgresql" {
  name        = "rds-guardduty"
  description = "Allow TLS inbound traffic to RDS Postgres"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-rds-guardduty"
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_postgresql.id
}
