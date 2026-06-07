output "bucket_id" {
  description = "Bucket name (same as ID for S3)"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Bucket ARN (for IAM policies)"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name (for CloudFront origin)"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}