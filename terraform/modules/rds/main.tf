# -----------------------------------
# AWS Secrets Manager
# -----------------------------------
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = "${var.common_tags.project}-${var.common_tags.environment}-db-credentials"
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}


# -----------------------------------
# RDS Subnet Group
# -----------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.common_tags.project}-${var.common_tags.environment}-app-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}

# -----------------------------------
# RDS
# -----------------------------------
data "aws_subnet" "app_subnet" {
  id = var.app_subnet_id
}

resource "aws_db_instance" "db" {
  identifier     = "${var.common_tags.project}-${var.common_tags.environment}-app-db"
  instance_class = "db.t3.micro"
  engine         = "mysql"
  engine_version = "8.0.41"
  username       = local.db_credentials.username
  password       = local.db_credentials.password

  allocated_storage     = 20
  max_allocated_storage = 30
  storage_encrypted     = true

  availability_zone      = data.aws_subnet.app_subnet.availability_zone
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false

  backup_window           = "04:00-05:00"
  backup_retention_period = 7
  maintenance_window      = "Mon:05:00-Mon:08:00"

  deletion_protection = false
  skip_final_snapshot = true
  apply_immediately   = true

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-app-db"
  }
}

# -----------------------------------
# RDS Security Group
# -----------------------------------
resource "aws_security_group" "db_sg" {
  name   = "${var.common_tags.project}-${var.common_tags.environment}-db-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-db-sg"
  }
}

resource "aws_security_group_rule" "app_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = var.app_sg_id
}