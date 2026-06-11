output "db_instance_address" {
  description = "RDS endpoint (host)"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "RDS endpoint (host:port)"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_arn" {
  value = aws_db_instance.this.arn
}