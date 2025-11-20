output "results_bucket_name" {
  description = "Navn på S3-bucketen for analyseresultater"
  value       = aws_s3_bucket.results.bucket
}

output "results_bucket_region" {
  description = "Regionen bucketen ligger i"
  value       = var.aws_region
}
