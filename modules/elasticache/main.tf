resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-redis-subnet-group"
  })
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.project_name}-redis"
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [var.security_group_id]

  # AOF 영속화는 cluster mode에서만 가능
  # 단일 노드는 RDB snapshot으로 대체 (매일 1회)
  snapshot_retention_limit = 1
  snapshot_window          = "16:00-17:00"

  tags = merge(var.tags, {
    Name = "${var.project_name}-redis"
  })
}