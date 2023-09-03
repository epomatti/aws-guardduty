# Lists
resource "aws_guardduty_ipset" "trusted" {
  activate    = true
  detector_id = var.guardduty_detector_id
  format      = "TXT"
  location    = "https://${aws_s3_bucket.ipset.bucket_domain_name}/${aws_s3_object.trusted.key}"
  name        = "trusted-ipset-001"
}

resource "aws_guardduty_threatintelset" "threat" {
  activate    = true
  detector_id = var.guardduty_detector_id
  format      = "TXT"
  location    = "https://${aws_s3_bucket.ipset.bucket_domain_name}/${aws_s3_object.threat.key}"
  name        = "threat-ipset-001"
}

# Resources
resource "aws_s3_bucket" "ipset" {
  bucket        = "bucket-guarduty-ipset-000"
  force_destroy = true
}

locals {
  trusted      = "trusted.txt"
  threat       = "threat.txt"
  trusted_path = "${path.module}/${local.trusted}"
  threat_path  = "${path.module}/${local.threat}"
}

resource "aws_s3_object" "trusted" {
  bucket = aws_s3_bucket.ipset.id
  key    = local.trusted
  source = local.trusted_path
  etag   = filemd5(local.trusted_path)
}

resource "aws_s3_object" "threat" {
  bucket = aws_s3_bucket.ipset.id
  key    = local.threat
  source = local.threat_path
  etag   = filemd5(local.threat_path)
}
