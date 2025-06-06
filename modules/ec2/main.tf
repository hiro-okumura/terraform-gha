# -----------------------------------
# EC2
# -----------------------------------
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ssm_parameter.amzn2_ami.value
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.iam_instance_profile
  vpc_security_group_ids      = [ aws_security_group.app_server.id ]
  associate_public_ip_address = true

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-app-server"
  }
}

# -----------------------------------
# Security Group
# -----------------------------------
resource "aws_security_group" "app_server" {
  vpc_id = var.vpc_id
  name   = "${var.common_tags.project}-${var.common_tags.environment}-app-server"

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-app-server"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_cidr_blocks
  security_group_id = aws_security_group.app_server.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_server.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_server.id
}