variable "environment_name" {
  type        = string
  description = "Set environment name"
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR"
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

variable "additional_tags" {
  type        = map(string)
  description = "Variable if additional tags are needed"
  default     = {}
}