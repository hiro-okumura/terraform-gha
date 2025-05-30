# -----------------------------------
# S3
# -----------------------------------
resource "random_string" "s3_suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.common_tags.project}-${var.common_tags.environment}-bucket-${random_string.s3_suffix.result}"

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-bucket-${random_string.s3_suffix.result}"
  }
}

resource "aws_s3_bucket_versioning" "app_bucket" {
  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------
# IAM Policy
# -----------------------------------
resource "aws_iam_policy" "s3_access" {
  name   = "${var.common_tags.project}-${var.common_tags.environment}-s3-access-policy"
  policy = data.aws_iam_policy_document.s3_access.json

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-s3-access-policy"
  }
}

data "aws_iam_policy_document" "s3_access" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.app_bucket.arn,
      "${aws_s3_bucket.app_bucket.arn}/*"
    ]
  }
}

# -----------------------------------
# IAM Role
# -----------------------------------
resource "aws_iam_role" "ec2_s3_access" {
  name               = "${var.common_tags.project}-${var.common_tags.environment}-s3-access-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-s3-access-role"
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# -----------------------------------
# Policy Attachment
# -----------------------------------
resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# -----------------------------------
# IAM Instance Profile
# -----------------------------------
resource "aws_iam_instance_profile" "ec2_s3_access" {
  name = "${var.common_tags.project}-${var.common_tags.environment}-ec2-s3-access-instance-profile"
  role = aws_iam_role.ec2_s3_access.name

  tags = {
    Name = "${var.common_tags.project}-${var.common_tags.environment}-ec2-s3-access-instance-profile"
  }
}