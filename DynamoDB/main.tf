provider "aws" {
  region = "us-east-1" 
}

resource "aws_dynamodb_table" "example_table" {
  name           = "example_table"
  billing_mode   = "PROVISIONED" 
  hash_key       = "UserId"  //  primary key
  range_key      = "date"    //  sort key
  read_capacity  = 1 
  write_capacity = 1 

  attribute {
    name = "UserId"
    type = "S" 
  }

  attribute {
    name = "date"
    type = "S" 
  }

  ttl {
    attribute_name = "expiration_time"
    enabled        = false
  }

  tags = {
    Name = "ExampleDynamoDBTable"
  }
}
