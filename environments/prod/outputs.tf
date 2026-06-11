output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "s3_bucket_id" {
  description = "S3 bucket name for image uploads"
  value       = module.s3_images.bucket_id
}

output "iam_ec2_instance_profile" {
  description = "EC2 instance profile name"
  value       = module.iam_ec2.instance_profile_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value     = module.rds.db_instance_address
  sensitive = true
}

output "redis_endpoint" {
  value = module.elasticache.redis_endpoint
}