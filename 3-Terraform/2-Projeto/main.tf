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

resource "aws_security_group_rule" "allow_ssh_access" {
 security_group_id = each.value
 type              = "ingress"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 cidr_blocks       = [data.aws_vpc.default.cidr_block]
}

resource "aws_security_group_rule" "allow_http_access" {
 security_group_id = each.value
 type              = "ingress"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 cidr_blocks       = [data.aws_vpc.default.cidr_block]
}