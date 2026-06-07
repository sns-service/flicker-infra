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