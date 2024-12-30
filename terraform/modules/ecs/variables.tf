variable "task_cpu" {
  description = "Task CPU units"
  type        = number
}

variable "task_memory" {
  description = "Task memory (MiB)"
  type        = number
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "task_family" {
  description = "ECS task family"
  type        = string
}

variable "cluster_name" {
  description = "ECS service name"
  type        = string
}

variable "container_name" {
  description = "Container Name"
  type        = string
}

variable "ecr_repository_url" {
  description = "ecr repo url"
  type        = string
}


variable "execution_role_arn" {
  description = "iam task execution role arn"
  type        = string
}



variable "task_role_arn" {
  description = "arn iam task role"
  type        = string
}

variable "target_group_arn" {
  description = "alb target group arn"
  type        = string
}

variable "private_subnets" {
  description = "list of private subnet ids"
  type        = list
}

variable "aws_region" {
  description = "aws region"
  type        = string
}