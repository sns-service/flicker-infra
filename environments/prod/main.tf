module "ecr" {
  source = "../../modules/ecr"

  name                   = var.project_name
  image_tag_mutability   = "MUTABLE"
  scan_on_push           = true
  lifecycle_policy_count = 10
}

module "s3_images" {
  source = "../../modules/s3"

  bucket_name = "${var.project_name}image"
  public_read_access = true
  cors_allowed_origins = [
    "http://a.simple-sns.link",
    "https://a.simple-sns.link",
  ]
  force_destroy = false
}

module "iam_ec2" {
  source = "../../modules/iam-ec2"

  role_name     = "${var.project_name}-ec2-role"
  s3_bucket_arn = module.s3_images.bucket_arn   # 의존성 입력
}

module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  vpc_cidr     = "10.0.0.0/16"
  azs          = ["ap-northeast-2a", "ap-northeast-2c"]

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  single_nat_gateway = true
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_id = module.network.alb_security_group_id
}

module "rds" {
  source = "../../modules/rds"

  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnet_ids
  security_group_id = module.network.db_security_group_id

  db_name     = "sns"
  db_username = var.db_username
  db_password = var.db_password
  instance_class = "db.t3.micro"
  multi_az    = false  # 학습용. 운영은 true
}

module "elasticache" {
  source = "../../modules/elasticache"

  project_name      = var.project_name
  subnet_ids        = module.network.private_subnet_ids
  security_group_id = module.network.redis_security_group_id
  node_type         = "cache.t3.micro"
}