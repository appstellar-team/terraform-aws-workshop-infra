resource "aws_iam_user" "user" {
  name = var.name
  tags = {
    environment = var.environment
  }
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user_policy" {
  name = "read_access"
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3BucketFullAccess",
      "Effect": "Allow",
      
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::appstellar-terraform-workshop-*"
    }
  ]
}
EOF
}
