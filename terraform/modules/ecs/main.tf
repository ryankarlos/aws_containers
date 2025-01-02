resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = var.task_def_family
  container_definitions = jsonencode([
    {
      name      = "frontend"
      essential = true
      image     = var.ecr_repository_url
      portMappings = [{
        appProtocol   = "http"
        containerPort = 80
        hostPort      = 80
        name          = "frontend-80-tcp"
        protocol      = "tcp"
      }]
  }])
  cpu                      = var.task_cpu
  execution_role_arn       = var.execution_role_arn
  memory                   = var.task_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.task_role_arn
  ephemeral_storage {
    size_in_gib = var.ephemeral_storage
  }
  runtime_platform {
    cpu_architecture        = var.runtime_platform["cpu_architecture"]
    operating_system_family = var.runtime_platform["operating_system_family"]
  }
}

resource "aws_ecs_service" "ecs_service" {
  availability_zone_rebalancing      = "ENABLED"
  cluster                            = aws_ecs_cluster.main.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  health_check_grace_period_seconds  = 0
  launch_type                        = "FARGATE"
  name                               = var.service_name
  task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn
  load_balancer {
    container_name   = var.container_name
    container_port   = var.container_port
    target_group_arn = var.target_group_arn
  }
  network_configuration {
    assign_public_ip = true
    security_groups  = var.security_groups
    subnets          = var.subnets
  }
}


resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 0
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}



resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "alb_request_target_tracking"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}