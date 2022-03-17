resource "aws_instance" "tfinstance" {
  ami             = "ami-0c02fb55956c7d316"
  count           = 1
  key_name        = "terraform"
  instance_type   = "t2.micro"
  security_groups = ["terraform_sg"]
  tags = {
    name = "terraform_instance"
  }

  user_data = <<EOF
  #! /bin/bash
  yum update -y
  yum install docker -y
  service docker start
  docker pull nginx
  docker run -it -d --name my-first-container -p 80:80 nginx
EOF
}

resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "sucurity group for terraform"

  ingress {
    from_port   = 80
    to_port     = 80
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65315
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "security_terraform_port"
  }
}