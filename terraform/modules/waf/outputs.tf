output "waf_id" {
  description = "The web acl id"
  value       = aws_wafv2_web_acl.waf_default.id
}

output "waf_arn" {
  description = "The web acl arn"
  value       = aws_wafv2_web_acl.waf_default.arn
}

