# Outputs from all modules

# Task 1: S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_storage.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_storage.bucket_arn
}

output "s3_bucket_website_url" {
  description = "S3 bucket website URL"
  value       = module.s3_storage.website_url
}

# Task 2: Lambda Outputs
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda_infrastructure.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda_infrastructure.function_arn
}

# Task 3: Container Outputs
output "ecs_cluster_name" {
  description = "Name of ECS cluster"
  value       = module.container_infrastructure.cluster_name
}

# Task 4: Monitoring Outputs
output "cloudwatch_dashboard_url" {
  description = "CloudWatch Dashboard URL"
  value       = module.monitoring.dashboard_url
}