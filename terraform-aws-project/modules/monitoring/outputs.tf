# Outputs for Monitoring Module

output "dashboard_url" {
  description = "CloudWatch Dashboard URL"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=${data.aws_region.current.name}#dashboards:name=${aws_cloudwatch_dashboard.main_dashboard.dashboard_name}"
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "alarm_arns" {
  description = "ARNs of all CloudWatch alarms"
  value = {
    lambda_errors    = aws_cloudwatch_metric_alarm.lambda_errors.arn
    lambda_duration  = aws_cloudwatch_metric_alarm.lambda_duration.arn
    lambda_throttles = aws_cloudwatch_metric_alarm.lambda_throttles.arn
    s3_4xx_errors   = aws_cloudwatch_metric_alarm.s3_4xx_errors.arn
  }
}