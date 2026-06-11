# ============ ALB ============
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-alb"
  })
}

# ============ Target Group - Blue ============
resource "aws_lb_target_group" "blue" {
  name        = "${var.project_name}-tg-blue"
  port        = var.blue_target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = 2
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = 2
    matcher             = "200"
  }

  # 블루/그린 전환 중 일시적 등록/해제 빈번 → 짧은 deregistration
  deregistration_delay = 30

  tags = merge(var.tags, {
    Name = "${var.project_name}-tg-blue"
    Color = "blue"
  })
}

# ============ Target Group - Green ============
resource "aws_lb_target_group" "green" {
  name        = "${var.project_name}-tg-green"
  port        = var.green_target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = 2
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = 2
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = merge(var.tags, {
    Name = "${var.project_name}-tg-green"
    Color = "green"
  })
}

# ============ HTTP Listener (initially → blue) ============
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  # GitHub Actions가 default_action을 동적으로 바꾸기 때문에
  # Terraform이 자동으로 되돌리지 못하게 ignore
  lifecycle {
    ignore_changes = [default_action]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-listener-http"
  })
}