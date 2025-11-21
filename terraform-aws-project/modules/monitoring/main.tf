# Monitoring Module - Task 4 (CloudWatch)

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-alerts"
}

# SNS Topic Subscription (Email)
resource "aws_sns_topic_subscription" "alert_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "student@example.com"  # Change this to your email
}

# Lambda Function Alarm - Error Rate
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.lambda_function_name}-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors lambda errors"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

# Lambda Function Alarm - Duration
resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  alarm_name          = "${var.lambda_function_name}-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = "3000"  # 3 seconds
  alarm_description   = "Lambda function taking too long"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

# Lambda Function Alarm - Throttles
resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "${var.lambda_function_name}-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Lambda function is being throttled"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

# S3 Bucket Alarm - 4xx Errors
resource "aws_cloudwatch_metric_alarm" "s3_4xx_errors" {
  alarm_name          = "${var.s3_bucket_name}-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrors"
  namespace           = "AWS/S3"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "S3 bucket 4xx errors"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    BucketName = var.s3_bucket_name
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main_dashboard" {
  dashboard_name = "${var.environment}-monitoring-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title   = "Lambda Function Metrics"
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          metrics = [
            ["AWS/Lambda", "Invocations", { stat = "Sum", label = "Invocations" }],
            [".", "Errors", { stat = "Sum", label = "Errors", yAxis = "right" }],
            [".", "Duration", { stat = "Average", label = "Avg Duration (ms)", yAxis = "right" }]
          ]
          period = 300
          stat   = "Average"
          yAxis = {
            left = {
              min = 0
            }
            right = {
              min = 0
            }
          }
        }
        width  = 12
        height = 6
        x      = 0
        y      = 0
      },
      {
        type = "metric"
        properties = {
          title   = "Lambda Concurrent Executions"
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          metrics = [
            ["AWS/Lambda", "ConcurrentExecutions", { stat = "Maximum" }],
            [".", "UnreservedConcurrentExecutions", { stat = "Maximum" }]
          ]
          period = 60
          stat   = "Maximum"
        }
        width  = 12
        height = 6
        x      = 12
        y      = 0
      },
      {
        type = "metric"
        properties = {
          title   = "S3 Bucket Metrics"
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          metrics = [
            ["AWS/S3", "BucketSizeBytes", { stat = "Average", label = "Bucket Size" }],
            [".", "NumberOfObjects", { stat = "Average", label = "Number of Objects", yAxis = "right" }]
          ]
          period = 86400  # Daily
          stat   = "Average"
        }
        width  = 12
        height = 6
        x      = 0
        y      = 6
      },
      {
        type = "log"
        properties = {
          title  = "Lambda Function Logs"
          region = data.aws_region.current.name
          query  = <<EOF
SOURCE '/aws/lambda/${var.lambda_function_name}'
| fields @timestamp, @message
| sort @timestamp desc
| limit 100
EOF
        }
        width  = 12
        height = 6
        x      = 12
        y      = 6
      },
      {
        type = "metric"
        properties = {
          title   = "API Gateway Metrics"
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          metrics = [
            ["AWS/ApiGateway", "Count", { stat = "Sum", label = "Request Count" }],
            [".", "4XXError", { stat = "Sum", label = "4xx Errors", yAxis = "right" }],
            [".", "5XXError", { stat = "Sum", label = "5xx Errors", yAxis = "right" }]
          ]
          period = 300
          stat   = "Sum"
        }
        width  = 24
        height = 6
        x      = 0
        y      = 12
      }
    ]
  })
}

# Custom Metric Filter for Lambda Errors
resource "aws_cloudwatch_log_metric_filter" "lambda_custom_errors" {
  name           = "${var.lambda_function_name}-custom-errors"
  log_group_name = "/aws/lambda/${var.lambda_function_name}"
  pattern        = "[ERROR]"

  metric_transformation {
    name      = "CustomErrors"
    namespace = "CustomApp/Lambda"
    value     = "1"
  }
}

# Get current region
data "aws_region" "current" {}