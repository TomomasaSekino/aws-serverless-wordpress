module "vpc" {
  source      = "../../modules/vpc"
  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
  az_count    = var.az_count
  tags        = local.common_tags
}

module "ecr" {
  source      = "../../modules/ecr"
  name_prefix = local.name_prefix
  repo_name   = "wordpress"
  tags        = local.common_tags
}

module "alb" {
  source      = "../../modules/alb"
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids
  tags        = local.common_tags
}

module "ecs" {
  source           = "../../modules/ecs_fargate"
  name_prefix      = local.name_prefix
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids # まずはpublicでOK（最短で動かす）
  alb_sg_id        = module.alb.alb_sg_id
  target_group_arn = module.alb.target_group_arn

  container_image  = "wordpress:6-php8.2-apache"
  container_port   = 80
  desired_count    = 1
  assign_public_ip = true

  environment = [
    { name = "WORDPRESS_DB_HOST", value = module.aurora.cluster_endpoint },
    { name = "WORDPRESS_DB_NAME", value = "wordpress" },
    { name = "WORDPRESS_DB_USER", value = "admin" },
    { name = "WORDPRESS_DB_PASSWORD", value = var.db_master_password },
    { name = "DEPLOY_REV", value = "rev-001" }
  ]

  tags = local.common_tags
}

module "aurora" {
  source                = "../../modules/aurora_serverless_v2"
  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  db_subnet_ids         = module.vpc.private_subnet_ids
  app_security_group_id = module.ecs.task_sg_id

  db_name         = "wordpress"
  master_username = "admin"
  master_password = var.db_master_password

  # 必要なら調整
  serverless_min_acu = 0.5
  serverless_max_acu = 2

  tags = local.common_tags
}
