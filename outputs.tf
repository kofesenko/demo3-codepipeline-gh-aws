output "alb_dns_name" {
  value = module.alb.load_balancer
}

output "ecr_url" {
  value = module.ecr.ecr_url
}