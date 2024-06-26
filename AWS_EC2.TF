provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["./aws/config"]
  shared_credentials_files = ["./aws/config"]
}

resource "aws_instance" "linux1" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-093713de8ea4c92257" # ID da Subnet
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

  key_name = "vockey"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y 
              sudo yum install -y amazon-efs-utils
              EOF

  tags = {
    Name = "Linux1"
  }
}


resource "aws_instance" "linux2" {
  ami                    = "ami-07caf09b362be10b8"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-093713de8ea4c9225" # ID da Subnet
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

  key_name = "vockey"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y 
              sudo yum install -y amazon-efs-utils
              EOF

  tags = {
    Name = "Linux2"
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_sg-5"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = "vpc-04c43d02ba76bb852"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "github_sha" {}

output "public_ip1" {
  value = aws_instance.linux1.public_ip
}
output "public_ip2" {
  value = aws_instance.linux2.public_ip
}
