# -------------------------------
# RDS parameter group
# -------------------------------

resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# -------------------------------
# RDS option group
# -------------------------------

resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# -------------------------------
# RDS subnet group
# -------------------------------

resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name       = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    project = var.project
    Env     = var.environment
  }
}

# -------------------------------
# RDS instance
# -------------------------------
# need 'terraform init' to use random_string
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {
  # Base
  engine               = "mysql"
  engine_version       = "8.0.41"
  identifier           = "${var.project}-${var.environment}-mysql-standalone"
  db_name              = "tastylog" # old terraform version, use db_name newest version
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

  username = "admin"
  password = random_string.db_password.result

  # Network
  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  # Storage
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_encrypted     = false

  # Backup
  backup_window              = "04:00-05:00"
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00"
  auto_minor_version_upgrade = false

  # Delete
  deletion_protection = false # need to set false to delete
  skip_final_snapshot = true  # need to set true to delete
  apply_immediately   = true  # need to set true to delete

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    project = var.project
    Env     = var.environment
  }
}




