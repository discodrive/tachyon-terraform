# Create IAM user with fullaccess permissions to API Gateway, IAM, S3, Lambda, CloudFront and ACM
resource "aws_iam_user" "user" {
  name = "tachyon-user"
}

resource "aws_iam_user_policy_attachment" "policy-attach" {
  user       = aws_iam_user.user.name
  for_each   = toset(var.iam_policy_arn)
  policy_arn = each.value
}

# Create a role to allow Lambda to access S3
resource "aws_iam_role" "b-lam-role" {
  name = "b-lam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Create Lambda function role policy
resource "aws_iam_role_policy" "b-lam-role-policy" {
  name = "LambdaFunctionIAMRole"
  role = aws_iam_role.b-lam-role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.b-lam.arn}/*",
          "arn:aws:s3:::${var.app_name}-assets"
        ]
        Effect = "Allow"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "arn:aws:logs:*:*:*"
        ]
        Effect = "Allow"
      }
    ]
  })
}
