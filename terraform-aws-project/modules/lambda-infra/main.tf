# Lambda Infrastructure Module - Task 2

# Lambda Execution Role
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Lambda Basic Execution Policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Policy for S3 Access
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "${var.function_name}-s3-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# CloudWatch Logs Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

# Lambda Function (Placeholder - actual code will be deployed separately)
resource "aws_lambda_function" "main_function" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 60
  memory_size   = 128

  # Dummy inline code - actual code will be deployed via SAM/CI-CD
  filename         = data.archive_file.lambda_placeholder.output_path
  source_code_hash = data.archive_file.lambda_placeholder.output_base64sha256

  environment {
    variables = {
      ENVIRONMENT    = var.environment
      S3_BUCKET_NAME = var.s3_bucket_name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_cloudwatch_log_group.lambda_logs
  ]
}

# Create placeholder Lambda code
data "archive_file" "lambda_placeholder" {
  type        = "zip"
  output_path = "/tmp/lambda-placeholder.zip"

  source {
    content  = <<EOF
import json
import os
import boto3

def handler(event, context):
    """
    Sample Lambda function for college assignment
    This will be replaced with actual code via SAM deployment
    """
    s3_bucket = os.environ.get('S3_BUCKET_NAME', 'not-set')
    environment = os.environ.get('ENVIRONMENT', 'unknown')

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'environment': environment,
            's3_bucket': s3_bucket,
            'event': event
        })
    }
EOF
    filename = "index.py"
  }
}

# API Gateway for Lambda (REST API)
resource "aws_api_gateway_rest_api" "lambda_api" {
  name        = "${var.function_name}-api"
  description = "API Gateway for Lambda function"
}

# API Gateway Resource
resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "execute"
}

# API Gateway Method
resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway Integration
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.main_function.invoke_arn
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "lambda_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name  = var.environment

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}