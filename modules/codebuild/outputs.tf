output "codebuild_project_name" {
  description = "CodeBuild Project name"
  value       = aws_codebuild_project.container_app_build.name
}