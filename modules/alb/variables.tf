variable "project_name" {
  description = "Project name (used as prefix)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (from network module)"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs (from network module)"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "ALB requires at least 2 subnets in different AZs."
  }
}

variable "security_group_id" {
  description = "ALB security group ID (from network module)"
  type        = string
}

variable "blue_target_port" {
  description = "Blue target port"
  type        = number
  default     = 8080
}

variable "green_target_port" {
  description = "Green target port"
  type        = number
  default     = 8081
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/actuator/health"
}

variable "health_check_interval" {
  description = "Health check interval (seconds)"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Consecutive successes for healthy"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}