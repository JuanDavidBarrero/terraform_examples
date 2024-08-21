data "archive_file" "zip_the_js_code" {
  type        = "zip"
  source_dir  = "${path.module}/python"
  output_path = "${path.module}/python/python-code.zip"
}

# Lambda Function
resource "aws_lambda_function" "iot_lambda" {
  filename         = data.archive_file.zip_the_js_code.output_path
  function_name    = var.lambda_function_name
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.runtime
}

output "lambda_arn" {
  value = aws_lambda_function.iot_lambda.arn
}
