resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-db"

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2  # autoscaling 상한
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  publicly_accessible    = false

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_days
  backup_window           = "16:00-17:00"   # UTC = KST 01:00-02:00
  maintenance_window      = "Sun:17:00-Sun:19:00"

  skip_final_snapshot       = true   # 학습용. 운영에선 false 권장
  deletion_protection       = false  # 학습용. 운영에선 true 권장
  performance_insights_enabled = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-db"
  })
}