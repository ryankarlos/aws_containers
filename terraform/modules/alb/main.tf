
resource "aws_lb" "app" {
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  name               = var.alb_name
  security_groups    = var.security_groups
  subnets            = var.subnets
}


resource "aws_lb_listener" "frontend_https" {
  certificate_arn   = aws_iam_server_certificate.ssl_cert.arn
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {

    target_group_arn = aws_lb_target_group.app.arn
    type             = "forward"
  }
}


resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_iam_server_certificate.ssl_cert.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.app.arn
    type             = "forward"
  }
}



resource "aws_lb_target_group" "app" {
  ip_address_type = "ipv4"
  name            = "default-target"
  port            = var.container_port
  protocol        = "HTTP"
  target_type     = "ip"
  vpc_id          = var.vpc_id
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
  }
}


resource "aws_iam_server_certificate" "ssl_cert" {
  name_prefix      = "ssl_cert"
  certificate_body = file(var.credentials.cert)
  private_key      = file(var.credentials.pk)

  lifecycle {
    create_before_destroy = true
  }
}

