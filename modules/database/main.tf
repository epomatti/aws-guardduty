resource "aws_db_instance" "default" {
  identifier     = "rds-guardduty"
  db_name        = "guarddutydb"
  engine         = "postgres"
  engine_version = "15.3"
  username       = "guardduty"
  password       = "p4ssw0rd"

  # Network
  db_subnet_group_name = aws_db_subnet_group.default.name
  availability_zone    = var.availability_zone
  publicly_accessible  = true

  # Resources
  instance_class    = "db.t4g.micro"
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
  apply_immediately           = false
  maintenance_window          = "Sun:05:00-Sun:06:00"

  blue_green_update {
    enabled = false
  }

  # Protect
  deletion_protection      = false
  skip_final_snapshot      = true
  delete_automated_backups = true
}

resource "aws_db_subnet_group" "default" {
  name       = var.workload
  subnet_ids = var.subnets
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "allow_postgresql" {
  name        = "rds-${var.workload}"
  description = "Allow TLS inbound traffic to RDS Postgres"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-rds-${var.workload}"
  }
}

resource "aws_security_group_rule" "ingress" {
  description       = "Allows connection to Postgres Private Endpoint"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.allow_postgresql.id
}
