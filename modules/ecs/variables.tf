variable "container_name" {
  default = "python-app"
}

variable "container_port" {
  description = "python app container port"
  default     = 5000
}

variable "environment_name" {
  type        = string
  description = "Set environment name"
  default     = ""
}

variable "region" {
  description = "Region"
  type        = string
  default     = ""
}

variable "ecr_url" {
    description = "ECR url"
}

variable "target_group_arns" {
  type    = string
  default = ""
}