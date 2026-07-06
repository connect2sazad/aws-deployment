# create s3 bucket
resource "aws_s3_bucket" "webserver_s3_bucket" {
  bucket = var.s3_bucket_name

  # this is only for practice purpose, remove if in production
  force_destroy = true

  tags = {
    Name        = "Server S3 Bucket"
    Environment = "Dev"
  }
}

# enable versioning for bucket
resource "aws_s3_bucket_versioning" "webserver_s3_bucket_versioning" {
  bucket = aws_s3_bucket.webserver_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# add encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "webserver_s3_bucket_encryption" {
  bucket = aws_s3_bucket.webserver_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# block the public access to acl and allow public access to s3 folder
resource "aws_s3_bucket_public_access_block" "webserver_s3_bucket_public_access" {
  bucket = aws_s3_bucket.webserver_s3_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}