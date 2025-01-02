variable "task_cpu" {
  description = "Task CPU units"
  type        = number
  default     = 1024
}

variable "task_memory" {
  description = "Task memory (MiB)"
  type        = number
  default     = 4096
}

variable "ephemeral_storage" {
  type    = number
  default = 21
}

variable "runtime_platform" {
  description = "runtime_platform mapping details"
  type        = map(any)
  default = {
    "cpu_architecture"        = "X86_64"
    "operating_system_family" = "LINUX"
  }
}


variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = "fast-api-service"
}


variable "cluster_name" {
  description = "ECS service name"
  type        = string
  default     = "devcluster"
}

variable "container_name" {
  description = "Container Name"
  type        = string
  default     = "frontend"
}

variable "task_def_family" {
  description = "Unique name for task def"
  type        = string
  default     = "default_task_def"
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


variable "ecs_cluster_name" {
  description = "name of ecs service"
  type        = string
  default     = "devcluster"
}


variable "load_balancer_name" {
  description = "load balancer name"
  type        = string
}



variable "subnets" {
  description = "list of subnet ids"
  type        = list(any)
}


variable "security_groups" {
  description = "list of security groups"
  type        = list(any)
}

variable "region" {
  description = "aws region"
  type        = string
}