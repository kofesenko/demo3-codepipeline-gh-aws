output "registry_id" {
  description = "The account ID"
  value       = aws_ecr_repository.python_app.registry_id
}
output "ecr_url" {
  description = "Repository address"
  value       = aws_ecr_repository.python_app.repository_url
}