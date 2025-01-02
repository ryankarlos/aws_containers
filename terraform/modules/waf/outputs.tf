output "waf_acl_id" {
  description = "The web acl id"
  value       = aws_wafv2_web_acl.waf_default.id
}
