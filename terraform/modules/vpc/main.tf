# -----------------------------------
# VPC
# -----------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-vpc"
  }
}


# -----------------------------------
# Subnet
# -----------------------------------
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-${each.key}"
  }
}

# -----------------------------------
# Internet Gateway
# -----------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-igw"
  }
}

# -----------------------------------
# Route Table
# -----------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-public"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-${each.key}"
  }
}

# -----------------------------------
# Route Table Association
# -----------------------------------
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}