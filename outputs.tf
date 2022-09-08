# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = module.vpc.vpc_id
# }

# output "public_subnets_id" {
#   description = "Public subnets ID in the VPC"
#   value       = module.vpc.public_subnets_id
# }

# output "private_subnets_id" {
#   description = "Private subnets ID in the VPC"
#   value       = module.vpc.private_subnets_id
# }

# output "target_group_arns" {
#   value = module.alb.target_group_arns
# }
output "alb_dns_name" {
  value = module.alb.load_balancer
}

output "ecr_url" {
  value = module.ecr.ecr_url
}