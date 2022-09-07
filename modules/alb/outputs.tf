output "load_balancer" {
  value = aws_lb.alb.dns_name
}
output "target_group_arns" {
  description = "Target group arn for ecs"
  value       = aws_lb_target_group.lb_target_group.arn
}

output "alb_sg" {
  description = "Security group needed for EC2 cluster"
  value       = aws_security_group.allow_alb.id
}
