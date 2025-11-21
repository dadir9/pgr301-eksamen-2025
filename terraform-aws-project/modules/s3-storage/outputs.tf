# Outputs for S3 Storage Module

output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.main_storage.id
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main_storage.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main_storage.arn
}

output "bucket_region" {
  description = "Region of the S3 bucket"
  value       = aws_s3_bucket.main_storage.region
}

output "website_url" {
  description = "Website URL of the S3 bucket"
  value       = "http://${aws_s3_bucket_website_configuration.main_website.website_endpoint}"
}