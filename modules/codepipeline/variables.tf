variable "artifacts_bucket_name" {
  description = "S3 Bucket for storing artifacts"
  default     = ""
}

variable "environment_name" {
  type        = string
  description = "Set environment name"
  default     = ""
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = ""
}
variable "codebuild_project_name" {
  description = "CodeBuild project name"
  type        = string
  default     = ""
}
variable "ghrepo" {
  description = "GitHub repository"
  type        = string
  default     = ""
}

variable "branch" {
  description = "Python project branch"
  default     = ""
}

variable "image_tag" {
  type        = string
  description = "ECR image tag"
  default     = ""
}

variable "container_name" {
  description = "Name for container"
  type        = string
  default     = ""
}

variable "ecr_url" {
  description = "ECR url"
  default     = ""
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = ""
}

variable "ecs_service_name" {
  description = "ECS service name"
  default     = ""
}

data "aws_caller_identity" "current" {}