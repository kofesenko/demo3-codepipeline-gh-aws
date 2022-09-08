variable "region" {
  description = "Region"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = []
}
variable "instance_type" {
  description = "Instance_type"
  type        = string
  default     = ""
}

variable "sg_alb_ingress_ports" {
  type    = list(string)
  default = []
}

variable "sg_asg_ingress_ports" {
  type    = list(string)
  default = []
}

variable "environment_name" {
  type        = string
  description = "Set environment name"
  default     = ""
}

variable "artifacts_bucket_name" {
  type        = string
  description = "S3 Bucket for storing artifacts"
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
  description = "ECR image tag"
  default     = ""
}

variable "container_name" {
  description = "Name for container"
  type        = string
  default     = ""
}