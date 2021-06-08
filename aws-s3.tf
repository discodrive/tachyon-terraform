# S3 bucket for Lambda functions
resource "aws_s3_bucket" "b-lam" {
  bucket = "${var.app_name}-lambda-functions"
  acl    = "public-read-write"

  tags = {
    Name = "Lambda functions"
  }
}

# S3 bucket for S3 proxy
resource "aws_s3_bucket" "assets" {
  bucket = "${var.app_name}-assets"
  acl    = "public-read-write"

  tags = {
    Name = "S3 Proxy"
  }
}

# S3 bucket for logs
resource "aws_s3_bucket" "logs" {
  bucket = "${var.app_name}-tachyon-logs"
  acl    = "private"
}

# Create the Tachyon directory in the proxy bucket
resource "aws_s3_bucket_object" "tachyon-dir" {
  bucket       = aws_s3_bucket.assets.id
  acl          = "public-read-write"
  key          = "tachyon"
  content_type = "application/x-directory"
}

# Create an Origin Access Identity to allow CloudFront to access the S3 bucket
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "This identity allows the CloudFront media distribution access to the required S3 bucket: ${var.app_name}-assets"
}
