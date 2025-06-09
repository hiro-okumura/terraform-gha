# -----------------------------------
# ALB
# -----------------------------------
resource "aws_lb" "this" {
  name               = "${var.common_tags.project}-${var.common_tags.environment}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
  internal           = false

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-alb"
  }
}

# -----------------------------------
# ALB Security Group
# -----------------------------------
resource "aws_security_group" "alb" {
  name   = "${var.common_tags.project}-${var.common_tags.environment}-alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-alb-sg"
  }
}

resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "app_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = var.app_server_sg_id
  security_group_id        = aws_security_group.alb.id
}

resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

# -----------------------------------
# ALB Listener
# -----------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# -----------------------------------
# ALB Target Group
# -----------------------------------
resource "aws_lb_target_group" "app" {
  name     = "${var.common_tags.project}-${var.common_tags.environment}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-alb-tg"
  }
}

# EC2に紐づける場合はアタッチメントが必要、今回はAuto Scaling Groupに紐付けるため不要
# resource "aws_lb_target_group_attachment" "app_attachment" {
#   target_group_arn = aws_lb_target_group.app.arn
#   target_id        = var.app_server_id
# }
