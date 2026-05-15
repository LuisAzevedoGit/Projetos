# 🔐 SSH Server Configuration and Authentication

## 📌 Objetivo

Configurar acesso remoto entre máquinas Linux utilizando SSH.

Neste projeto foi configurado:
- OpenSSH Server
- acesso remoto via password
- autenticação com SSH Keys
- acesso sem password

---

# 🧠 Conceitos Aprendidos

- SSH
- Remote access
- Linux networking
- Authentication
- Public and private keys
- Secure remote administration
- SSH key-based authentication

---

# 🌐 Ambiente do Projeto

Duas máquinas virtuais configuradas no VirtualBox utilizando rede Host-Only.

Exemplo:

| Máquina | IP |
|---|---|
| VM 1 | 192.168.56.101 |
| VM 2 | 192.168.56.102 |

---

# 📦 Instalar OpenSSH

## Instalar cliente e servidor SSH

```bash
sudo apt install openssh-client openssh-server
```

---

# ▶️ Iniciar Serviço SSH

## Iniciar serviço

```bash
sudo systemctl start sshd
```

---

## Ativar no arranque do sistema

```bash
sudo systemctl enable sshd
```

---

## Verificar estado do serviço

```bash
sudo systemctl status sshd
```

Exemplo:

```bash
active (running)
```

---

# 🌐 Verificar Endereço IP

```bash
ip addr show
```

ou

```bash
hostname -I
```

---

# 🔑 Ligação SSH com Password

## Conectar remotamente

```bash
ssh devops@192.168.56.102
```

Depois inserir a password do utilizador.

---

# 🔐 Configuração SSH com Keys

## 📌 Objetivo

Permitir autenticação sem password utilizando chaves SSH.

Mais seguro e muito utilizado em ambientes DevOps.

---

# 🛠️ Gerar SSH Key

Na máquina cliente executar:

```bash
ssh-keygen
```

Este comando cria:
- chave privada
- chave pública

---

# 📂 Localização das Keys

As chaves ficam guardadas em:

```bash
~/.ssh/
```

Exemplo:

| Ficheiro | Descrição |
|---|---|
| `id_rsa` | Chave privada |
| `id_rsa.pub` | Chave pública |

---

# 📤 Copiar Key para o Servidor

Depois de gerar a key:

```bash
ssh-copy-id devops@192.168.56.102
```

Este comando:
- copia a chave pública
- adiciona ao servidor remoto
- configura autenticação automática

---

# 🚀 Acesso SSH sem Password

Após copiar a key:

```bash
ssh devops@192.168.56.102
```

Já não será necessário inserir password.

---

# 🔍 Verificar Keys no Servidor

As chaves autorizadas ficam em:

```bash
~/.ssh/authorized_keys
```

---

# 🔐 Vantagens do SSH Key Authentication

- Mais seguro
- Mais rápido
- Evita brute force attacks
- Muito utilizado em automação
- Essencial em DevOps

---

# 🧪 Testes Realizados

## ✅ SSH com password

```bash
ssh devops@192.168.56.102
```

---

## ✅ SSH com key authentication

```bash
ssh-copy-id devops@192.168.56.102
```

---

## ✅ Verificação do serviço SSH

```bash
sudo systemctl status sshd
```

---

# 🚀 Melhorias Futuras

- Desativar login por password
- Desativar root login
- Configurar firewall UFW
- Instalar Fail2Ban
- Alterar porta SSH
- Automatizar configuração SSH

---

# 📚 Tecnologias Utilizadas

- Ubuntu Server
- OpenSSH
- Linux CLI
- VirtualBox
- SSH Keys
- Linux Networking
