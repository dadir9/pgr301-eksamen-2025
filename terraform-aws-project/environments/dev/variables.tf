# Variables for Dev Environment

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"  # N. Virginia - best for student account
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "college-demo"
}