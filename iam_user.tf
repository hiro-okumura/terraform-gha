# -------------------------------
# IAM Policy
# -------------------------------
resource "aws_iam_policy" "billing_deny" {
  name        = "${var.project}-${var.environment}-billing-deny-iam-policy"
  description = "Deny billing actions"
  policy      = data.aws_iam_policy_document.billing_deny.json
}

data "aws_iam_policy_document" "billing_deny" {
  statement {
    effect = "Deny"
    actions = [
      "aws-portal:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "iam_change_own_password" {
  name        = "${var.project}-${var.environment}-iam-change-own-password-iam-policy"
  description = "Allow IAM user to change their own password"
  policy      = data.aws_iam_policy_document.iam_change_own_password.json
}

data "aws_iam_policy_document" "iam_change_own_password" {
  statement {
    effect = "Allow"
    actions = [
      "iam:ChangePassword"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }
}

# -------------------------------
# IAM Group
# -------------------------------

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "developers_readonly_policy" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


resource "aws_iam_group" "billing_deny" {
  name = "${var.project}-${var.environment}-billing-deny-iam-group"
}

resource "aws_iam_group_policy_attachment" "billing_deny" {
  group = aws_iam_group.billing_deny.name
  policy_arn = aws_iam_policy.billing_deny.arn
}

resource "aws_iam_group" "iam_change_own_password" {
  name = "${var.project}-${var.environment}-iam-change-own-password-iam-group"
}

resource "aws_iam_group_policy_attachment" "iam_change_own_password" {
  group = aws_iam_group.iam_change_own_password.name
  policy_arn = aws_iam_policy.iam_change_own_password.arn
}