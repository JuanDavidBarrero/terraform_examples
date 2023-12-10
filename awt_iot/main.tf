provider "aws" {
  region = "us-east-1"  # Cambia la región según tus necesidades
}

resource "aws_iot_thing" "esp32_thing" {
  name = "ESP32_TERRAFORM"
}

resource "aws_iot_policy" "esp32_policy" {
  name        = "allow_all_policy"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iot:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iot_certificate" "my_certificates" {
  active = true
}

resource "aws_iot_policy_attachment" "policy_attachment" {
  policy = aws_iot_policy.esp32_policy.name
  target = aws_iot_certificate.my_certificates.arn
}


resource "aws_iot_thing_principal_attachment" "certificate_attachment" {
  thing       = aws_iot_thing.esp32_thing.name
  principal        = aws_iot_certificate.my_certificates.arn
}

output "certificate_pem" {
  value = aws_iot_certificate.my_certificates.certificate_pem
  sensitive = true
}

output "private_key" {
  value = aws_iot_certificate.my_certificates.private_key
  sensitive = true
}

output "ca_certificate_pem" {
  value = aws_iot_certificate.my_certificates.ca_certificate_id
}
