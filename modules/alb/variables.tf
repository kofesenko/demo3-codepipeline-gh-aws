variable "vpc_id" {
  type    = string
  default = ""
}

variable "security_group_id" {
  description = "security group id"
  type        = string
  default     = ""
}
variable "public_subnets_id" {
  description = "Public subnets id"
  type        = list(string)
  default     = []
}

variable "private_subnets_id" {
  description = "Private subnets id"
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}

variable "sg_alb_ingress_ports" {
  type    = list(string)
  default = []
}
