resource "aws_s3_bucket" "bucket49394" {
  bucket = "bucket49394"  # Ensure the bucket name is globally unique
  acl    = "private"  # Sets the access control list, e.g., private, public-read

  tags = {
    Name        = "My S3 Bucket"
    Environment = "Dev"
  }
}
