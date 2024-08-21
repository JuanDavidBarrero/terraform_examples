variable "iot_thing_name" {
  type        = string
  description = "Name of the IoT Thing"
}

variable "lambda_arn" {
  type        = string
  description = "ARN of the Lambda function to trigger"
}
