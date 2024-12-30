module "ecr" {
  source          = "./modules/ecr"
  repository_name = "${var.project}-repo"
}

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
}

module "alb" {
  source            = "./modules/alb"
  alb_name          = "${var.project}-alb"
  vpc_id            = var.vpc_id
  public_subnets    = var.public_subnets
  certificate_arn   = module.acm.certificate_arn
  container_port    = var.container_port
  target_group_name = "${var.project}-tg"
}

module "iam" {
  source = "./modules/iam"

  project        = var.project
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  s3_bucket_arn  = var.s3_bucket_arn
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name       = "${var.project}-cluster"
  task_family        = "${var.project}-task"
  service_name       = "${var.project}-service"
  container_name     = "${var.project}-container"
  ecr_repository_url = module.ecr.repository_url
  container_port     = var.container_port
  target_group_arn   = module.alb.target_group_arn
  private_subnets    = var.private_subnets
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  aws_region         = var.aws_region
  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
}
