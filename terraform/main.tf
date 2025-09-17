provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "devops_server" {
  ami           = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = var.key_name

  user_data = file("${path.module}/../scripts/setup.sh")

  tags = {
    Name = "DevOpsPOC"
  }

  vpc_security_group_ids = [aws_security_group.devops_sg.id]
}

resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Allow SSH, Jenkins, Tomcat"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
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
