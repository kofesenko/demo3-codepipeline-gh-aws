variable "public_subnets_id" {
  description = "A list of public subnets id inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets_id" {
  description = "A list of private subnets id inside the VPC"
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}
variable "aws_ami_id" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
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

variable "alb_sg" {
  description = "ALB security group"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default = ""
}