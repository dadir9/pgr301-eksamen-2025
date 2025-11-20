locals {
  bucket_name = "kandidat-${var.candidate_id}-data"
}

resource "aws_s3_bucket" "results" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "results_lifecycle" {
  bucket = aws_s3_bucket.results.id

  rule {
    id     = "temporary-files"
    status = "Enabled"

    filter {
      prefix = "midlertidig/"
    }

    transition {
      days          = var.tmp_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.tmp_expiration_days
    }
  }
}
