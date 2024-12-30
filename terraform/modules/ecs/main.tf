resource "aws_ecs_cluster" "ecs_cluster" {
  name     = "devcluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  container_definitions = jsonencode([{
    command     = ["--config=/etc/ecs/ecs-cloudwatch-xray.yaml"]
    environment = []
    essential   = true
    image       = "public.ecr.aws/aws-observability/aws-otel-collector:v0.41.1"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/ecs-aws-otel-sidecar-collector"
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
        max-buffer-size       = "25m"
        mode                  = "non-blocking"
      }
    }
    mountPoints    = []
    name           = "aws-otel-collector"
    portMappings   = []
    systemControls = []
    volumesFrom    = []
    }, {
    environment      = []
    environmentFiles = []
    essential        = true
    image            = "376337229415.dkr.ecr.us-east-1.amazonaws.com/fast_api_ecs:latest"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/default_task_def"
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
        max-buffer-size       = "25m"
        mode                  = "non-blocking"
      }
      secretOptions = []
    }
    mountPoints = []
    name        = "frontend"
    portMappings = [{
      appProtocol   = "http"
      containerPort = 80
      hostPort      = 80
      name          = "frontend-80-tcp"
      protocol      = "tcp"
    }]
    systemControls = []
    ulimits        = []
    volumesFrom    = []
  }])
  cpu                      = jsonencode(1024)
  execution_role_arn       = "arn:aws:iam::376337229415:role/ECSTaskExecutionRole"
  family                   = "default_task_def"
  ipc_mode                 = null
  memory                   = jsonencode(4096)
  network_mode             = "awsvpc"
  pid_mode                 = null
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = null
  tags                     = {}
  tags_all                 = {}
  task_role_arn            = "arn:aws:iam::376337229415:role/ECSTaskRole"
  track_latest             = false
  ephemeral_storage {
    size_in_gib = 21
  }
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "ecs_service" {
  availability_zone_rebalancing      = "ENABLED"
  cluster                            = "arn:aws:ecs:us-east-1:376337229415:cluster/devcluster"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  force_delete                       = null
  force_new_deployment               = null
  health_check_grace_period_seconds  = 0
  iam_role                           = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  launch_type                        = "FARGATE"
  name                               = "fast-api-service"
  platform_version                   = "1.4.0"
  propagate_tags                     = "NONE"
  scheduling_strategy                = "REPLICA"
  tags                               = {}
  tags_all                           = {}
  task_definition                    = "default_task_def:1"
  triggers                           = {}
  wait_for_steady_state              = null
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  load_balancer {
    container_name   = "frontend"
    container_port   = 80
    elb_name         = null
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:376337229415:targetgroup/default-target/a87d3ab88c185eed"
  }
  network_configuration {
    assign_public_ip = true
    security_groups  = ["sg-048d64314bdae5e24"]
    subnets          = ["subnet-04fd3ba1aa9d56cb0"]
  }
}
