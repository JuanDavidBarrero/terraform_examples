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


# please use https://www.mailinator.com/ to test emial
