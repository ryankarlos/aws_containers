
variable "alb_name" {
  description = "load balancer name"
  type        = string
  default     = "default-load-balancer"
}

variable "vpc_id" {
  description = "vpc id"
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


variable "target_group_name" {
  description = "alb target group name"
  type        = string
  default     = "default-target"
}


variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "enable_stickiness" {
  description = "Enable stickiness"
  type        = bool
  default     = false
}


variable "credentials" {
  type = object(
    {
      cert = string
      pk   = string
    }
  )
  description = <<-_EOT
  {
    cert : "path to ssl certificate"
    pk = "path to private key"
  }
  _EOT
}

