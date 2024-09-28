data "aws_s3_bucket" "my_bucket" {
  name = "bucket49394"
}
resource "aws_s3_bucket" "bucket49394" {
  count = length(data.aws_s3_buck.my_bucket.id) == 0 ? 1 : 0
  bucket = "bucket49394"  # Ensure the bucket name is globally unique
  acl    = "private"  # Sets the access control list, e.g., private, public-read

  tags = {
    Name        = "My S3 Bucket"
    Environment = "Dev"
  }
}
