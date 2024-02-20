provider "aws" {
  region = "us-east-1"
}

resource "aws_sqs_queue" "example_queue" {
  name                       = "my-sqs-queue"
  visibility_timeout_seconds = 300
}

resource "aws_cloudwatch_event_bus" "example_event_bus" {
  name = "EventBusHades"
}

resource "aws_cloudwatch_event_rule" "example_rule" {
  name           = "example-custom-rule"
  description    = "Example custom rule"
  event_bus_name = aws_cloudwatch_event_bus.example_event_bus.name

  event_pattern = jsonencode({
    "detail-type" : ["CheckoutBasket"],
    "source" : ["com.swn.basket.checkoutbasket"]
  })
}

resource "aws_cloudwatch_event_target" "example_target" {
  rule           = aws_cloudwatch_event_rule.example_rule.name
  event_bus_name = aws_cloudwatch_event_bus.example_event_bus.name

  target_id = "example-target"
  arn       = aws_sqs_queue.example_queue.arn
}

resource "aws_sqs_queue_policy" "example_queue_policy" {
  queue_url = aws_sqs_queue.example_queue.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": aws_sqs_queue.example_queue.arn,
        "Condition": {
          "ArnEquals": {
            "aws:SourceArn": aws_cloudwatch_event_rule.example_rule.arn
          }
        }
      }
    ]
  })
}

output "event_bus_arn" {
  value = aws_cloudwatch_event_bus.example_event_bus.arn
}
