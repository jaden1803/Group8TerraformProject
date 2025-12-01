/*terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

data "aws_iam_policy_document" "ec2_s3_readonly" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "web_role" {
  name = "Group8-${var.env_name}-WebRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_policy" "web_policy" {
  name   = "Group8-${var.env_name}-WebS3ReadOnly"
  policy = data.aws_iam_policy_document.ec2_s3_readonly.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.web_role.name
  policy_arn = aws_iam_policy.web_policy.arn
}

resource "aws_iam_instance_profile" "web_profile" {
  name = "Group8-${var.env_name}-WebProfile"
  role = aws_iam_role.web_role.name
}
*/
