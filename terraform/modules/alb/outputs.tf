output "target_group_arn" {
  description = "elb target group arn"
  value       = aws_lb_target_group.app.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.app.arn
}