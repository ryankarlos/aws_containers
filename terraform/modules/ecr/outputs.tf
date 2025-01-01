output "registry_id" {
  description = "The account ID of the registry holding the repository."
  value       = aws_ecr_repository.app.registry_id
}

output "repository_url" {
  description = "The URL of the repository."
  value       = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  description = "The arn of the repository."
  value       = aws_ecr_repository.app.arn
}


output "trigged_by" {
  value = null_resource.docker_packaging.triggers
}