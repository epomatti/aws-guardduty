locals {
  affix = "guardduty-test-box"
}

resource "aws_iam_instance_profile" "box" {
  name = "test-instance"
  role = aws_iam_role.box.id
}

resource "aws_instance" "box" {
  ami           = var.ami
  instance_type = var.instance_type

  associate_public_ip_address = true
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [aws_security_group.box.id]

  availability_zone    = var.az
  iam_instance_profile = aws_iam_instance_profile.box.id
  user_data            = file("${path.module}/userdata/${var.user_data}")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring    = true
  ebs_optimized = true

  root_block_device {
    encrypted  = true
    kms_key_id = aws_kms_key.main.arn
  }

  lifecycle {
    ignore_changes = [
      ami,
      associate_public_ip_address,
      user_data
    ]
  }

  tags = {
    Name = "${local.affix}"
  }
}

### IAM Role ###

resource "aws_iam_role" "box" {
  name = local.affix

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.box.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.box.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  role       = aws_iam_role.box.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.box.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_security_group" "box" {
  name        = "ec2-ssm-${local.affix}"
  description = "Controls access for EC2 via Session Manager"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-ssm-${local.affix}"
  }
}

resource "aws_security_group_rule" "allow_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.box.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.box.id
}

### KMS ###
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_region     = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "main" {
  description             = "kms-ec2-guardduty-key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          "AWS" : "arn:aws:iam::${local.aws_account_id}:root"
        }
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "GuardyDutyEC2Malware"
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Resource = "*"
      },
    ]
  })
}
