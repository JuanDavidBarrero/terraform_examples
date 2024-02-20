provider "aws" {
  region = "us-east-1" 
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_db_instance" "example_instance" {
  identifier            = "mydatabase"
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mariadb"
  engine_version        = "10.4.21"        //Change this to the needed version
  instance_class        = "db.t2.micro"
  username              = "admin"
  password              = random_password.db_password.result
  publicly_accessible  = false
  
  tags = {
    Name = "ExampleMariaDBInstance"
  }
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true  #
}
