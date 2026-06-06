
variable "name" {
  description = "ECR repository name"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "s"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Scan images on push for vulnerabilities"
  type        = bool
  default     = true
}

# "ECR에 보관할 이미지 개수를 설정"
variable "lifecycle_policy_count" {
  description = "Number of recent images to retain (older ones auto-deleted)"
  type        = number
  default     = 10
}

# ECR Repository 태그 설정
variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}