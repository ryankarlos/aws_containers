module "ecr" {
  source          = "../modules/ecr"
  repository_name = var.repository_name
  region          = var.region
  dkr_img_src_path = var.dkr_img_src_path
  image_tag = var.image_tag

}

module "alb" {
  source          = "../modules/alb"
  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = var.security_groups
  credentials     = var.credentials
}

module "iam" {
  source = "../modules/iam"
}

module "ecs" {
  source             = "../modules/ecs"
  ecr_repository_url = join(":", [module.ecr.repository_url, var.image_tag])
  target_group_arn   = module.alb.target_group_arn
  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  security_groups  = var.security_groups
  subnets          = var.subnets
  load_balancer_name = module.alb.alb_arn
}


module "waf" {
  source             = "../modules/waf"
}

resource "aws_wafregional_web_acl_association" "waf_elb_integration" {
  resource_arn = module.alb.alb_arn
  web_acl_id   = module.waf.web_acl_id
}

