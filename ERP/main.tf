module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones

  project_name = var.project_name
  environment  = var.environment
}

module "security_groups" {
  source = "./modules/sg"

  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id

  db_username = var.db_username
  db_password = var.db_password
  db_name     = "dbuser"
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  alb_sg_id      = module.security_groups.alb_sg_id
  frontend_sg_id = module.security_groups.frontend_sg_id
  backend_sg_id  = module.security_groups.backend_sg_id

  ecs_execution_role_arn = module.iam.ecs_execution_role_arn

  aws_region    = var.aws_region
  project_name  = var.project_name
  environment   = var.environment
  frontend_image = var.frontend_image
  backend_image  = var.backend_image

  db_username = var.db_username
  db_password = var.db_password

  rds_endpoint = module.rds.rds_endpoint
}

# ================================
# NEW — InfluxDB EC2 MODULE
# ================================
module "influxdb" {
  source            = "./modules/influxdb"
  ami               = var.influxdb_ami
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  sg_id             = module.security_groups.influxdb_sg_id

  project_name      = var.project_name
  environment       = var.environment
}


# ================================
# NEW — Grafana EC2 MODULE
# ================================
module "grafana" {
  source = "./modules/grafana"

  public_subnet_id = module.vpc.public_subnet_ids[0]
  sg_id            = module.security_groups.grafana_sg_id
  ami              = var.grafana_ami

  project_name     = var.project_name
  environment      = var.environment

  instance_type    = var.grafana_instance_type
  influxdb_url     = module.influxdb.influxdb_private_ip
}
