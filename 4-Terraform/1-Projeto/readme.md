# ☁️ Terraform AWS EC2 — Primeira Infraestrutura como Código (IaC)

## 📌 Objetivo

Criar uma **instância EC2 Ubuntu na AWS** utilizando **Terraform**.

O objetivo deste projeto foi aprender os conceitos base de **Infrastructure as Code (IaC)**:

- Terraform
- AWS Provider
- Resource Creation
- AWS Authentication
- Terraform Workflow

Toda a infraestrutura foi criada **sem utilizar AWS Console manualmente**.

---

## 🧠 Tecnologias Utilizadas

- Terraform
- AWS
- EC2
- IAM
- Ubuntu Server

---

## 📂 Estrutura do Projeto

```text
terraform-aws-ec2/
│
└── main.tf
```

---

## ⚙️ Configuração Terraform

### `main.tf`

```hcl
terraform {

  required_providers {

    aws = {
      source = "hashicorp/aws"
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
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-ubuntu-server"
  }

}
```

---

## 🔐 Configuração AWS CLI

Foi criado um **IAM User dedicado** para Terraform.

**Não foi utilizada a conta root da AWS.**

AWS Console:

```text
IAM
→ Users
→ Create User
→ Permissions → AdministratorAccess
```

Criar credenciais:

```text
IAM User
→ Security Credentials
→ Create Access Key
```

---

### Configuração local

Instalação AWS CLI:

```bash
sudo apt install awscli -y
```

Configuração:

```bash
aws configure
```

Preenchido:

```text
AWS Access Key ID
AWS Secret Access Key
Region: eu-north-1
Output: json
```

Teste:

```bash
aws sts get-caller-identity
```

---

## 🚀 Workflow Terraform

### Inicializar Projeto

```bash
terraform init
```

Instala o provider AWS.

---

### Ver Plano de Execução

```bash
terraform plan
```

Mostra os recursos que serão criados.

Resultado esperado:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
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

✔ AWS EC2 Instance

✔ Ubuntu Server

✔ Região eu-north-1

---

### Destruir Recursos

Para evitar custos:

```bash
terraform destroy
```

---

## ☁️ Infraestrutura Criada

| Configuração | Valor |
|--------------|-------|
| Cloud Provider | AWS |
| Serviço | EC2 |
| Sistema Operativo | Ubuntu |
| Tipo Instância | t2.micro |
| Região | eu-north-1 |
| Provisionamento | Terraform |

---

## 🛠️ Comandos Utilizados

Verificar Terraform:

```bash
terraform version
```

Inicializar:

```bash
terraform init
```

Validar:

```bash
terraform validate
```

Ver plano:

```bash
terraform plan
```

Criar infraestrutura:

```bash
terraform apply
```

Apagar infraestrutura:

```bash
terraform destroy
```

---

## ✅ Resultado Final

Terraform criou automaticamente uma **EC2 Ubuntu na AWS**.

Instância visível em:

```text
AWS Console
→ EC2
→ Instances
```

Estado:

```text
Running
```

Este projeto introduz os conceitos fundamentais de **Terraform + AWS + Infrastructure as Code (IaC)**.
