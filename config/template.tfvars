# General
aws_region = "us-east-2"

# RDS
create_rds         = false
rds_instance_class = "db.t4g.medium"

# EC2
ami           = "ami-06f50fcd71f272ce1" # Canonical, Ubuntu Server Pro, 22.04 LTS, amd64 jammy image build on 2024-06-06
instance_type = "t4g.micro"
user_data     = "ubuntu2204pro.sh"
