# Outputs for Container Infrastructure Module

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main_cluster.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main_cluster.arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app_repository.repository_url
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.app_task.arn
}