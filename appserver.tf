# -------------------------------
# Key Pair
# -------------------------------

# resource "aws_key_pair" "keypair" {
#   key_name   = "${var.project}-${var.environment}-keypair"
#   public_key = file("./src/keypair-name.pub")

#   tags = {
#     Name    = "${var.project}-${var.environment}-keypair"
#     project = var.project
#     Env     = var.environment
#   }
# }

# -------------------------------
# EC2 Instance
# -------------------------------

# resource "aws_instance" "app_server" {
#   ami                  = data.aws_ami.app.id
#   instance_type        = "t2.micro"
#   key_name             = "my-ec2-key-pair"
#   iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name

#   subnet_id                   = aws_subnet.public_subnet_1a.id
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.app_sg.id, aws_security_group.opmng_sg.id]

#   tags = {
#     Name    = "${var.project}-${var.environment}-app-ec2"
#     project = var.project
#     Env     = var.environment
#     Type    = "app"
#   }
# }

# -------------------------------
# Launch Template
# -------------------------------

resource "aws_launch_template" "app_lt" {
  update_default_version = true

  name = "${var.project}-${var.environment}-app-lt"

  image_id = data.aws_ami.app.id

  key_name = var.key_name

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project}-${var.environment}-app-ec2"
      project = var.project
      Env     = var.environment
      Type    = "app"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id, aws_security_group.opmng_sg.id]
    delete_on_termination       = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.app_ec2_profile.name
  }

  user_data = filebase64("./src/initialize.sh")
}

# -------------------------------
# Auto Scaling Group
# -------------------------------

resource "aws_autoscaling_group" "app_asg" {
  name = "${var.project}-${var.environment}-app-asg"

  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  health_check_grace_period = 300
  health_check_type         = "ELB"

  vpc_zone_identifier = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]

  target_group_arns = [aws_lb_target_group.alb_target_group.arn]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.app_lt.id
        version            = "$Latest"
      }
      override {
        instance_type = "t2.micro"
      }
    }
  }
}

# -------------------------------
# SSM Parameter Store
# -------------------------------

resource "aws_ssm_parameter" "host_name" {
  description = "Host name for app server"
  name        = "/${var.project}/${var.environment}/app/MYSQL_HOST"
  type        = "String"
  value       = aws_db_instance.mysql_standalone.address
}

resource "aws_ssm_parameter" "port" {
  description = "Port for app server"
  name        = "/${var.project}/${var.environment}/app/MYSQL_PORT"
  type        = "String"
  value       = aws_db_instance.mysql_standalone.port
}

resource "aws_ssm_parameter" "database" {
  description = "Database name for app server"
  name        = "/${var.project}/${var.environment}/app/MYSQL_DATABASE"
  type        = "String"
  value       = aws_db_instance.mysql_standalone.name
}

resource "aws_ssm_parameter" "username" {
  description = "Username for app server"
  name        = "/${var.project}/${var.environment}/app/MYSQL_USERNAME"
  type        = "SecureString"
  value       = aws_db_instance.mysql_standalone.username
}

resource "aws_ssm_parameter" "password" {
  description = "Password for app server"
  name        = "/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
  type        = "SecureString"
  value       = aws_db_instance.mysql_standalone.password
}

