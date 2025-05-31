# -----------------------------------
# RDS Subnet Group
# -----------------------------------
resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = "${var.common_tags.project}-${var.common_tags.environment}-app-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}

# -----------------------------------
# RDS
# -----------------------------------
data "aws_subnet" "app_server_subnet" {
  id = var.ec2_subnet_id
}

# RDSは学習用として簡易な構成とする
resource "aws_db_instance" "app_db" {
  identifier     = "${var.common_tags.project}-${var.common_tags.environment}-app-db"
  instance_class = "db.t3.micro"
  engine         = "mysql"
  engine_version = "8.0.41"
  username       = var.db_username
  manage_master_user_password = true

  # Storage
  allocated_storage = 20
  max_allocated_storage = 30
  storage_encrypted = true

  # Network
  availability_zone = data.aws_subnet.app_server_subnet.availability_zone
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.app_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false

  # Delete
  deletion_protection = false # need to set false to delete
  skip_final_snapshot = true  # need to set true to delete
  apply_immediately   = true  # need to set true to delete

#   # Backupを有効化する場合
#   backup_window              = "04:00-05:00"
#   backup_retention_period    = 7
#   maintenance_window         = "Mon:05:00-Mon:08:00"
#   auto_minor_version_upgrade = false

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

resource "aws_security_group_rule" "db_sg_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.db_sg.id
  source_security_group_id = var.ec2_sg_id
}

# # SGのデフォルト設定のため明示的に設定する必要はない
# resource "aws_security_group_rule" "db_sg_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   security_group_id = aws_security_group.db_sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }