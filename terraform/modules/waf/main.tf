

locals {
  waf_id = "${aws_wafv2_web_acl.waf_default.id}/${var.waf_name}/${var.waf_scope}"

}

resource "aws_wafv2_web_acl" "waf_default" {
  name  = var.waf_name
  scope = var.waf_scope
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









