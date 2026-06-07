variable "bucket_name" {
  description = "S3 bucket name (globally unique)"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable bucket versioning"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Allow Terraform to delete non-empty bucket (USE WITH CAUTION)"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "CORS allowed origins (empty = no CORS rule)"
  type        = list(string)
  default     = []
}

variable "public_read_access" {
  description = "Allow public read access (for image hosting)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}