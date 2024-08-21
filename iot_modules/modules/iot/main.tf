
resource "aws_iot_thing" "iot_thing" {
  name = var.iot_thing_name
}


resource "aws_iot_certificate" "cert" {
  active = true
}


resource "aws_iot_thing_principal_attachment" "thing_cert_attach" {
  thing     = aws_iot_thing.iot_thing.name
  principal = aws_iot_certificate.cert.arn
}


resource "aws_iot_policy" "iot_policy" {
  name   = "IoTPolicy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "iot:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
}


resource "aws_iot_policy_attachment" "attach_cert_policy" {
  policy = aws_iot_policy.iot_policy.name
  target = aws_iot_certificate.cert.arn
}


resource "aws_iot_topic_rule" "rule" {
  enabled     = true
  name        = "IoTRule"
  description = "Trigger Lambda"
  sql         = "SELECT * FROM 'iot/topic'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = var.lambda_arn
  }

  depends_on = [aws_iot_policy.iot_policy, aws_iot_certificate.cert]
}
