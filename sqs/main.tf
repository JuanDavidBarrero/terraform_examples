provider "aws" {
  region = "us-east-1"  
}

resource "aws_sns_topic" "my_topic" {
  name = "my-sns-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "email"
  endpoint  = "example@mailinator.com" 
}

resource "aws_sqs_queue" "my_queue" {
  name                      = "my-sqs-queue"
  visibility_timeout_seconds = 300
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_queue.arn
}

resource "aws_sqs_queue_policy" "my_queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal": {
          "Service": "sns.amazonaws.com"
        },
        "Action" : "sqs:SendMessage",
        "Resource" : aws_sqs_queue.my_queue.arn,
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : aws_sns_topic.my_topic.arn
          }
        }
      }
    ]
  })
}
