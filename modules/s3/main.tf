resource "aws_s3_bucket" "main" {
  bucket = "s3-guarduty-12736dcsjak"

  force_destroy = true

  tags = {
    Name = "guardduty-bucket-test"
  }
}
