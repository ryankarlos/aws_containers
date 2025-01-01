
resource "aws_wafv2_web_acl" "waf_default" {
  name  = "load-balance-waf"
  scope = "REGIONAL"
  custom_response_body {
    content = jsonencode({
      error = "WAF access denied"
    })
    content_type = "APPLICATION_JSON"
    key          = "waf-block"
  }
  default_action {
    allow {
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 0

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "rate-limiting"
    priority = 2

    action {
      captcha {}
    }

    statement {
      rate_based_statement {
        limit                 = 10
        evaluation_window_sec = 60
        aggregate_key_type    = "IP"

      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "load-balance-waf"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "load-balance-waf"
    sampled_requests_enabled   = true
  }
}









