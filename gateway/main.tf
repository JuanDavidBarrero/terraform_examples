provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for executing Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}

data "archive_file" "zip_the_js_code" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/js"
  output_path = "${path.module}/lambda/js/index.zip"
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/python"
  output_path = "${path.module}/lambda/python/index.zip"
}

resource "aws_lambda_function" "create_function_js" {
  filename      = data.archive_file.zip_the_js_code.output_path
  function_name = "createFunctionJS"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"
}

resource "aws_lambda_function" "get_function_py" {
  filename      = data.archive_file.zip_the_python_code.output_path
  function_name = "getFunctionPy"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}


resource "aws_api_gateway_rest_api" "example_api" {
  name        = "example-api"
  description = "Ejemplo de API REST con Terraform"
}

resource "aws_api_gateway_resource" "example_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.example_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration_js" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.example_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_function_js.invoke_arn
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.example_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration_py" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.example_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_function_py.invoke_arn
}

resource "aws_lambda_permission" "apigw_invoke_py" {
  statement_id  = "AllowAPIGatewayInvokePy"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_function_py.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.example_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_invoke_js" {
  statement_id  = "AllowAPIGatewayInvokeJS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_function_js.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.example_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "example_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  stage_name  = var.environment
}

resource "aws_api_gateway_stage" "example_api_stage" {
  deployment_id = aws_api_gateway_deployment.example_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  stage_name    = var.environment
}

output "example_api_base_url" {
  value = aws_api_gateway_stage.example_api_stage.invoke_url
}

output "post_method_endpoint" {
  value = "${aws_api_gateway_stage.example_api_stage.invoke_url}/example"
}

output "get_method_endpoint" {
  value = "${aws_api_gateway_stage.example_api_stage.invoke_url}/example"
}