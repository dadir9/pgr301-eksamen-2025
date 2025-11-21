# Variables for Monitoring Module

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function to monitor"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to monitor"
  type        = string
}