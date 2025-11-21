# Main Terraform Configuration for Dev Environment
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend ko local rakha hai for simplicity, production me S3 use karo
  backend "local" {
    path = "terraform.tfstate"
  }
}

# AWS Provider Configuration - using default profile (student)
provider "aws" {
  region  = var.aws_region
  profile = "student"  # AWS student profile

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "college-assignment"
      ManagedBy   = "terraform"
      Student     = "true"
    }
  }
}

# Task 1: S3 Module
module "s3_storage" {
  source = "../../modules/s3-storage"

  environment  = var.environment
  bucket_name  = "${var.project_name}-storage-${var.environment}"
  enable_versioning = true
}

# Task 2: Lambda Infrastructure Module
module "lambda_infrastructure" {
  source = "../../modules/lambda-infra"

  environment     = var.environment
  function_name   = "${var.project_name}-function-${var.environment}"
  s3_bucket_arn   = module.s3_storage.bucket_arn
  s3_bucket_name  = module.s3_storage.bucket_name
}

# Task 3: Container Infrastructure Module (Simplified ECS)
module "container_infrastructure" {
  source = "../../modules/container-infra"

  environment    = var.environment
  cluster_name   = "${var.project_name}-cluster-${var.environment}"
  container_name = "sample-app"
}

# Task 4: Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  environment           = var.environment
  lambda_function_name  = module.lambda_infrastructure.function_name
  s3_bucket_name       = module.s3_storage.bucket_name
}