```hcl
#############################################
# Terraform Configuration
#############################################

terraform {

  # Define os providers necessários
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Versão mínima do Terraform
  required_version = ">= 1.5.0"
}

#############################################
# AWS Provider
#############################################

provider "aws" {

  # Região onde os recursos serão criados
  region = "eu-north-1"
}

#############################################
# VPC
#############################################

resource "aws_vpc" "main" {

  # Rede privada principal
  # Intervalo de IPs disponíveis:
  # 10.0.0.0 até 10.0.255.255
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

#############################################
# Internet Gateway
#############################################

resource "aws_internet_gateway" "igw" {

  # Liga a VPC à Internet
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

#############################################
# Public Subnet
#############################################

resource "aws_subnet" "public" {

  # Subnet pertence à VPC criada acima
  vpc_id = aws_vpc.main.id

  # Intervalo de IPs desta subnet
  cidr_block = "10.0.1.0/24"

  # Dá IP público automaticamente
  # às instâncias criadas nesta subnet
  map_public_ip_on_launch = true

  # Availability Zone
  availability_zone = "eu-north-1a"

  tags = {
    Name = "public-subnet"
  }
}

#############################################
# Route Table
#############################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  # Regra:
  # Todo o tráfego destinado à Internet
  # passa pelo Internet Gateway
  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

#############################################
# Route Table Association
#############################################

resource "aws_route_table_association" "public" {

  # Associa a subnet pública
  subnet_id = aws_subnet.public.id

  # À route table criada acima
  route_table_id = aws_route_table.public.id
}

#############################################
# Security Group
#############################################

resource "aws_security_group" "web_server_sg" {

  name        = "web-server-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ###########################################
  # SSH
  ###########################################

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    # Permite SSH de qualquer lugar
    cidr_blocks = ["0.0.0.0/0"]
  }

  ###########################################
  # HTTP
  ###########################################

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    # Permite acesso web
    cidr_blocks = ["0.0.0.0/0"]
  }

  ###########################################
  # Saída
  ###########################################

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    # Permite tráfego para qualquer destino
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

#############################################
# EC2 Ubuntu
#############################################

resource "aws_instance" "ubuntu_server" {

  # Ubuntu Server
  ami = "ami-05d62b9bc5a6ca605"

  # Free Tier elegível 
  instance_type = "t3.micro"

  # Coloca a EC2 dentro da subnet
  subnet_id = aws_subnet.public.id

  # Associa o Security Group
  vpc_security_group_ids = [
    aws_security_group.web_server_sg.id
  ]

  # Nome da Key Pair existente na AWS
  key_name = "terraform-key"

  ###########################################
  # Script executado no primeiro arranque
  ###########################################

  user_data = <<-EOF
#!/bin/bash

apt update -y

apt install nginx -y

systemctl enable nginx

systemctl start nginx
EOF

  tags = {
    Name = "terraform-ubuntu-server"
  }
}

#############################################
# Outputs
#############################################

output "public_ip" {

  description = "IP público da EC2"

  value = aws_instance.ubuntu_server.public_ip
}

output "instance_id" {

  description = "ID da instância"

  value = aws_instance.ubuntu_server.id
}
```
