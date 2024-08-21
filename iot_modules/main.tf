provider "aws" {
  region = "us-east-1"  
}

module "iam" {
  source = "./modules/iam"

  role_name         = "LambdaExecutionRole"
  policy_name       = "IoTLambdaPolicy"
  iot_permissions   = ["iot:*"]
  log_permissions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
}


module "lambda" {
  source = "./modules/lambda"

  lambda_function_name = "IoTLambdaFunction"
  role_arn             = module.iam.role_arn
  runtime              = "python3.8"
}


module "iot" {
  source = "./modules/iot"

  lambda_arn     = module.lambda.lambda_arn
  iot_thing_name = "MyIoTThing"
}
