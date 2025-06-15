# -----------------------------------
# Launch Template
# -----------------------------------
resource "aws_launch_template" "app" {
  update_default_version = true
  name                   = "${var.common_tags.project}-${var.common_tags.environment}-app-launch-template"
  image_id               = var.ami
  instance_type          = var.instance_type # Auto scaling Groupでも指定できる
  key_name               = var.key_name

  network_interfaces {
    security_groups             = [aws_security_group.app.id]
    associate_public_ip_address = true
    delete_on_termination       = true
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.common_tags.project}-${var.common_tags.environment}-asg-launch"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.common_tags.project}-${var.common_tags.environment}-asg-launch"
    }
  }
}

# -----------------------------------
# Auto Scaling Group
# -----------------------------------
resource "aws_autoscaling_group" "app" {
  name = "${var.common_tags.project}-${var.common_tags.environment}-asg"

  min_size         = 2
  max_size         = 2
  desired_capacity = 2

  health_check_grace_period = 300
  health_check_type         = "ELB"

  vpc_zone_identifier = var.public_subnet_ids

  target_group_arns = [var.alb_target_group_arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}

# -----------------------------------
# Security Group
# -----------------------------------
resource "aws_security_group" "app" {
  vpc_id = var.vpc_id
  name   = "${var.common_tags.project}-${var.common_tags.environment}-app-sg"

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-app-sg"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_cidr_blocks
  security_group_id = aws_security_group.app.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app.id
}

resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app.id
}