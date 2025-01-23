# General
aws_region = "us-east-2"

# RDS
create_rds = false

# EC2
ami           = "ami-0a7e9bed072bb379b" # Canonical, Ubuntu Server Pro, 22.04 LTS, amd64 jammy image build on 2024-06-06
instance_type = "t4g.micro"
user_data     = "ubuntu2204pro.sh"
