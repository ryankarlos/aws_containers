
resource "aws_lb" "app" {
  client_keep_alive                                            = 3600
  drop_invalid_header_fields                                   = false
  enable_cross_zone_load_balancing                             = true
  enable_deletion_protection                                   = false
  enable_http2                                                 = true
  idle_timeout                                                 = 60
  internal                                                     = false
  ip_address_type                                              = "ipv4"
  load_balancer_type                                           = "application"
  name                                                         = "default-load-balancer"
  security_groups                                              = ["sg-048d64314bdae5e24"]
  subnets                                                      = ["subnet-04fd3ba1aa9d56cb0", "subnet-0e165015f85692b36"]
}


resource "aws_lb_listener" "https" {
  certificate_arn          = "arn:aws:iam::376337229415:server-certificate/custom-cert"
  load_balancer_arn        = "arn:aws:elasticloadbalancing:us-east-1:376337229415:loadbalancer/app/default-load-balancer/0d080e8be712d7ff"
  port                     = 443
  protocol                 = "HTTPS"
  ssl_policy               = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    order            = 1
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:376337229415:targetgroup/default-target/a87d3ab88c185eed"
    type             = "forward"
    forward {
      stickiness {
        duration = 3600
        enabled  = true
      }
      target_group {
        arn    = "arn:aws:elasticloadbalancing:us-east-1:376337229415:targetgroup/default-target/a87d3ab88c185eed"
        weight = 1
      }
    }
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn        = "arn:aws:elasticloadbalancing:us-east-1:376337229415:loadbalancer/app/default-load-balancer/0d080e8be712d7ff"
  port                     = 80
  protocol                 = "HTTP"
  default_action {
    order            = 1
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:376337229415:targetgroup/default-target/a87d3ab88c185eed"
    type             = "forward"
    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = "arn:aws:elasticloadbalancing:us-east-1:376337229415:targetgroup/default-target/a87d3ab88c185eed"
        weight = 100
      }
    }
  }
}



resource "aws_lb_target_group" "app" {
  deregistration_delay               = jsonencode(300)
  ip_address_type                    = "ipv4"
  load_balancing_algorithm_type      = "round_robin"
  load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
  name                               = "default-target"
  port                               = 80
  protocol                           = "HTTP"
  protocol_version                   = "HTTP1"
  slow_start                         = 0
  target_type                        = "ip"
  vpc_id                             = "vpc-05c7628a7a70e7e0f"
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = jsonencode(200)
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = jsonencode(1)
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}

