provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "devops_server" {
  ami           = "ami-0059ed5a3aacdfe15" # Amazon Linux AMI
  instance_type = "t2.micro"
  key_name      = var.key_name

  user_data = file("${path.module}/../scripts/setup.sh")

  tags = {
    Name = "DevopsPOC"
  }

  vpc_security_group_ids = [aws_security_group.devops_sg.id]
}

resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Allow SSH, Jenkins, Tomcat (Docker)"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Dockerized Java App"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Tomcat (native)"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
