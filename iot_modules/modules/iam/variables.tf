variable "role_name" {
  type        = string
  description = "Name of the IAM role for Lambda execution"
}

variable "policy_name" {
  type        = string
  description = "Name of the IAM policy for IoT and CloudWatch"
}

variable "iot_permissions" {
  type        = list(string)
  description = "Permissions related to IoT"
}

variable "log_permissions" {
  type        = list(string)
  description = "Permissions related to CloudWatch Logs"
}
