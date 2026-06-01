# ☁️ Terraform AWS EC2 + SSH Access — Infraestrutura como Código (IaC)

## 📌 Objetivo

Criar uma instância EC2 Ubuntu na AWS utilizando Terraform e configurar o acesso remoto via SSH através de um Security Group.

O objetivo deste projeto foi aprofundar os conhecimentos de Infrastructure as Code (IaC), adicionando regras de segurança e acesso remoto a uma máquina virtual na cloud.

### Conceitos abordados

* Terraform
* AWS Provider
* EC2 Instances
* Security Groups
* SSH Access
* AWS Authentication
* Terraform Workflow
* Infrastructure as Code (IaC)

Toda a infraestrutura foi criada automaticamente através de código, sem configuração manual dos recursos na AWS.

---

## 🧠 Tecnologias Utilizadas

* Terraform
* AWS
* EC2
* VPC
* Security Groups
* IAM
* Ubuntu Server
* SSH

---

## 📂 Estrutura do Projeto

```text
terraform-aws-ec2-ssh/
│
└── main.tf
```

---

## ⚙️ Configuração Terraform

### main.tf

```hcl
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

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ssh_sg" {
  name        = "allow-ssh"
  description = "Allow SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "ubuntu_server" {
  ami           = "ami-05d62b9bc5a6ca605"
  instance_type = "t3.micro"

  key_name = "terraform-key"

  vpc_security_group_ids = [
    aws_security_group.ssh_sg.id
  ]

  tags = {
    Name = "terraform-ubuntu-server"
  }
}
```

---

## 🔐 Configuração AWS CLI

Foi criado um IAM User dedicado para utilização do Terraform.

Não foi utilizada a conta root da AWS.

### AWS Console

```text
IAM
→ Users
→ Create User
→ Permissions
→ AdministratorAccess
```

### Criar Access Keys

```text
IAM User
→ Security Credentials
→ Create Access Key
```

---

## 💻 Configuração Local

### Instalar AWS CLI

```bash
sudo apt install awscli -y
```

### Configurar Credenciais

```bash
aws configure
```

Preencher:

```text
AWS Access Key ID
AWS Secret Access Key
Default region: eu-north-1
Default output format: json
```

### Testar Autenticação

```bash
aws sts get-caller-identity
```

---

## 🚀 Workflow Terraform

### Inicializar Projeto

```bash
terraform init
```

Instala o provider AWS e prepara o ambiente.

---

### Validar Configuração

```bash
terraform validate
```

Verifica se existem erros de sintaxe.

---

### Ver Plano de Execução

```bash
terraform plan
```

Resultado esperado:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

---

### Criar Infraestrutura

```bash
terraform apply
```

Confirmar:

```text
yes
```

Terraform cria automaticamente:

* EC2 Ubuntu Server
* Security Group
* Regra de SSH
* Associação do Security Group à instância

---

### Obter o IP Público

```bash
terraform state show aws_instance.ubuntu_server
```

Procurar:

```text
public_ip = "X.X.X.X"
```

---

### Ligar por SSH

```bash
chmod 400 terraform-key.pem
```

```bash
ssh -i terraform-key.pem ubuntu@IP_PUBLICO
```

Exemplo:

```bash
ssh -i terraform-key.pem ubuntu@13.53.xx.xx
```

---

### Destruir Infraestrutura

Para evitar custos desnecessários:

```bash
terraform destroy
```

---

## ☁️ Infraestrutura Criada

| Configuração      | Valor          |
| ----------------- | -------------- |
| Cloud Provider    | AWS            |
| Serviço           | EC2            |
| Sistema Operativo | Ubuntu         |
| Tipo de Instância | t3.micro       |
| Região            | eu-north-1     |
| Segurança         | Security Group |
| Porta SSH         | 22             |
| Provisionamento   | Terraform      |

---

## 🔒 Segurança

Neste projeto a porta SSH foi configurada para aceitar ligações a partir de qualquer origem:

```hcl
cidr_blocks = ["0.0.0.0/0"]
```

Esta configuração é adequada para ambientes de laboratório e aprendizagem.

Em ambientes de produção é recomendado restringir o acesso SSH ao endereço IP da equipa ou administrador responsável.

---

## ✅ Resultado Final

Terraform criou automaticamente:

* Uma instância EC2 Ubuntu
* Um Security Group
* Regras de acesso SSH
* Associação entre os recursos

A instância ficou acessível remotamente através de SSH utilizando uma Key Pair da AWS.

### Estado Final

```text
Running
```

Este projeto consolida os conceitos fundamentais de Terraform, AWS, EC2, Security Groups e gestão de infraestrutura através de código.
