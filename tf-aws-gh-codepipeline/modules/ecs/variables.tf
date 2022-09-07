variable "container_name" {
  default = "python-app"
}

variable "container_port" {
  description = "Python app container port"
  default     = ""
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
variable "image_tag" {
  type = string
  default = ""
}