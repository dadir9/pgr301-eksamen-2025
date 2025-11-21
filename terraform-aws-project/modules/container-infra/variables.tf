# Variables for Container Infrastructure Module

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "container_name" {
  description = "Name of the container/application"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}