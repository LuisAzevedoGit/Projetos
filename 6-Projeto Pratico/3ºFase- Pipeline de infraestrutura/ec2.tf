
# criar uma chave pelo terminal: ssh-keygen -t ed25519 -f ~/.ssh/meu-website-key -C "meu-website"


resource "aws_key_pair" "website" {
  key_name   = "meu-website-key"
  public_key =  file("${path.module}/keys/meu-website-key.pub")
  #public_key = file("~/.ssh/meu-website-key.pub") fase 2
}


#criar ec2
resource "aws_instance" "website_server" {
  ami                    = "ami-06cfeaaa22092f09d"
  key_name               = aws_key_pair.website.key_name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.website_sg.id]            # associar o security group
  iam_instance_profile   = aws_iam_instance_profile.ec2_ecr_profile.name #associar o profile iam

  tags = {
    Name        = "ec2_website"
    Provisioned = "Terraform"
    Cliente     = "Luis"
  }
}




#criar security group
resource "aws_security_group" "website_sg" {
  name        = "security group do site"
  description = "create security group"
  vpc_id      = "vpc-0d048213ad1ccc183"

  tags = {
    Name        = "website-sg"
    Provisioned = "Terraform"
    Cliente     = "Luis"
  }

}

#regra cesso por ssh, apenas para o meu ip
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.website_sg.id #atrelar esta regra ao security group anterior
  cidr_ipv4         = "123.123.123.123/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#regra pcesso por http
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.website_sg.id #atrelar esta regra ao security group anterior
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
#regra acesso por https
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.website_sg.id #atrelar esta regra ao security group anterior
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

#regra permitir permitir ec2 acesso a internet
resource "aws_vpc_security_group_egress_rule" "allow_internet" { #para fazer download ao docker e atualizar sistemas
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# -----------------------------------------------------------
# IAM Role para a EC2 aceder ao ECR (pull de imagens)
# -----------------------------------------------------------

# 1) Trust policy: define QUEM pode assumir a role (o serviço EC2)
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# 2) A Role
resource "aws_iam_role" "ec2_ecr_role" {
  name               = "EC2-ECR-Role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# 3) Permissões: policy gerida pela AWS (só leitura no ECR)
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# 4) Instance profile: é isto que se liga à EC2 (a role sozinha não chega)
#    Na consola a AWS cria-o automaticamente; em Terraform tens de o criar.
resource "aws_iam_instance_profile" "ec2_ecr_profile" {
  name = "EC2-ECR-Profile"
  role = aws_iam_role.ec2_ecr_role.name
}
