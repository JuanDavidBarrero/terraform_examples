variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "role_arn" {
  type        = string
  description = "ARN of the IAM role for Lambda execution"
}

variable "runtime" {
  type        = string
  description = "Runtime for the Lambda function"
}
