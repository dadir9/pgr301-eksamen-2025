# S3 Storage Module - Task 1

# Random suffix for unique bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Main S3 Bucket
resource "aws_s3_bucket" "main_storage" {
  bucket = "${var.bucket_name}-${random_string.bucket_suffix.result}"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "College Assignment Storage"
  }
}

# Bucket Versioning
resource "aws_s3_bucket_versioning" "main_versioning" {
  bucket = aws_s3_bucket.main_storage.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main_encryption" {
  bucket = aws_s3_bucket.main_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Public Access Block (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "main_pab" {
  bucket = aws_s3_bucket.main_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle Rule for Cost Optimization
resource "aws_s3_bucket_lifecycle_configuration" "main_lifecycle" {
  bucket = aws_s3_bucket.main_storage.id

  rule {
    id     = "cleanup-old-files"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# Static Website Hosting (Optional feature)
resource "aws_s3_bucket_website_configuration" "main_website" {
  bucket = aws_s3_bucket.main_storage.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Sample index.html for static website
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.main_storage.id
  key          = "index.html"
  content_type = "text/html"
  content      = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>College Assignment - S3 Static Website</title>
</head>
<body>
    <h1>Welcome to Terraform S3 Module</h1>
    <p>This is a demo static website hosted on S3</p>
    <p>Environment: ${var.environment}</p>
</body>
</html>
EOF
}