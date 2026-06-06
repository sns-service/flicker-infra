module "ecr" {
  source = "../../modules/ecr"

  name                   = var.project_name
  image_tag_mutability   = "MUTABLE"
  scan_on_push           = true
  lifecycle_policy_count = 10
}