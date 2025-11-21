# Outputs for Lambda Infrastructure Module

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.main_function.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.main_function.arn
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = "${aws_api_gateway_deployment.lambda_deployment.invoke_url}/execute"
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}