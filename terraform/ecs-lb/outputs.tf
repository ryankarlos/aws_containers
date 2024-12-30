# ECR Outputs
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

# ACM Outputs
output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = module.acm.certificate_arn
}

output "acm_certificate_domain_validation_options" {
  description = "Domain validation options for the ACM certificate"
  value       = module.acm.domain_validation_options
}

# ALB Outputs
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = module.alb.alb_arn
}

output "alb_target_group_arn" {
  description = "The ARN of the target group"
  value       = module.alb.target_group_arn
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = module.alb.alb_zone_id
}

# ECS Outputs
output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "ecs_service_id" {
  description = "The ID of the ECS service"
  value       = module.ecs.service_id
}

output "ecs_task_definition_arn" {
  description = "The ARN of the Task Definition"
  value       = module.ecs.task_definition_arn
}

# IAM Outputs
output "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = module.iam.ecs_execution_role_arn
}

output "ecs_execution_role_name" {
  description = "The name of the ECS execution role"
  value       = module.iam.ecs_execution_role_name
}

output "ecs_task_role_arn" {
  description = "The ARN of the ECS task role"
  value       = module.iam.ecs_task_role_arn
}

output "ecs_task_role_name" {
  description = "The name of the ECS task role"
  value       = module.iam.ecs_task_role_name
}

# Security Group Outputs (if you have them in your ALB or ECS modules)
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = module.alb.security_group_id
}

output "ecs_security_group_id" {
  description = "The ID of the ECS tasks security group"
  value       = module.ecs.security_group_id
}

# Additional Useful Outputs
output "environment" {
  description = "The environment name"
  value       = var.environment
}

output "project_name" {
  description = "The project name"
  value       = var.project
}

output "aws_region" {
  description = "The AWS region used"
  value       = var.aws_region
}
