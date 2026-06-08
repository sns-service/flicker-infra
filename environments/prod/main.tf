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