# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Policy for IoT and CloudWatch Logs permissions
resource "aws_iam_policy" "iot_lambda_policy" {
  name = var.policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.iot_permissions
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = var.log_permissions
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "attach_iot_lambda_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.iot_lambda_policy.arn
}

output "role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}
