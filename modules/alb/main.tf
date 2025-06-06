# -----------------------------------
# ALB
# -----------------------------------
resource "aws_lb" "alb" {
  name = "${var.common_tags.project}-${var.common_tags.environment}-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = var.subnet_ids
  internal = false

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-alb"
  }
}

# -----------------------------------
# ALB Security Group
# -----------------------------------
resource "aws_security_group" "alb_sg" {
  name   = "${var.common_tags.project}-${var.common_tags.environment}-alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-alb-sg"
  }
}

resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_to_instance" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = var.app_server_sg_id
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# -----------------------------------
# ALB Listener
# -----------------------------------
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

# -----------------------------------
# ALB Target Group
# -----------------------------------
resource "aws_lb_target_group" "alb_target_group" {
  name = "${var.common_tags.project}-${var.common_tags.environment}-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-alb-tg"
  }
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id = var.app_server_id
}
