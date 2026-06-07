variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN to grant access (from s3 module output)"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}