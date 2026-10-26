terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ubuntu_server" {
  ami           = "ami-05d62b9bc5a6ca605"
  instance_type = "t3.micro"

  tags = {
    Name = "EC2 instance with ubuntu"
  }
}
