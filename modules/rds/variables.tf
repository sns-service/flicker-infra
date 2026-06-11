variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Private subnet IDs (multi-AZ)"
  type        = list(string)
}

variable "security_group_id" {
  description = "DB security group ID"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "sns"
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "engine_version" {
  type    = string
  default = "8.0"
}

variable "multi_az" {
  description = "Multi-AZ deployment (costs 2x, recommended for prod)"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}