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