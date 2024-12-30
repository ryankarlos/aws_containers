
variable "alb_name" {
  description = "load balancer name"
  type        = string
}

variable "tags" {
  description = "tag"
  type        = string
}


variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "public_subnets" {
  description = "list of public subnet ids"
  type        = list
}


variable "certificate_arn" {
  description = "arn of ssl cert"
  type        = string
}

variable "target_group_name" {
  description = "alb target group name"
  type        = string
}


variable "container_port" {
  description = "Container port"
  type        = number
}