provider "aws" {
  region = "us-east-1" # Change the region as needed
}

resource "tls_private_key" "example_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example_key_pair" {
  key_name   = "example-key-pair"
  public_key = tls_private_key.example_key_pair.public_key_openssh
}

resource "aws_security_group" "example_security_group" {
  name        = "example-security-group"
  description = "Allow inbound SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.example_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.example_security_group.id]  # Cambiado de security_groups a vpc_security_group_ids

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  depends_on = [aws_security_group.example_security_group]
}


output "public_key" {
  value = aws_key_pair.example_key_pair.public_key
}

output "private_key" {
  value     = tls_private_key.example_key_pair.private_key_pem
  sensitive = true
}
