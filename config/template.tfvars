# General
aws_region = "us-east-2"

# EC2: Ubuntu Pro 24.04 LTS
ami           = "ami-0a1d23463e8df329c"
instance_type = "t4g.micro"
user_data     = "ubuntu-pro-24_04-lts.sh"

# S3
create_s3 = false

# RDS: PostgreSQL
create_rds         = false
rds_instance_class = "db.t4g.medium"
rds_engine_version = "17.7"
