output "cluster_name" {
    description = "Name of the cluster"
    value = aws_ecs_cluster.python_app_cluster.name
}

output "service_name" {
    description = "Name of the service"
    value = aws_ecs_service.python_service.name
}