output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.vpc.id, "")
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet[*].id
}
