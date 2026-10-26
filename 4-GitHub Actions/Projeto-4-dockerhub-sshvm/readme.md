# 🚀 CI/CD Deploy Automático para AWS EC2 com Docker + GitHub Actions

## 📌 Objetivo

Criar um pipeline **CI/CD completo** utilizando:

- Flask
- Docker
- DockerHub
- GitHub Actions
- AWS EC2
- SSH Deploy

O objetivo do projeto é automatizar todo o processo de deployment.

Sempre que existe um **push para a branch `main`**, o GitHub Actions:

1. Faz checkout do código
2. Constrói a imagem Docker
3. Faz login no DockerHub
4. Envia a imagem para DockerHub
5. Liga à EC2 via SSH
6. Faz pull da nova imagem
7. Reinicia automaticamente o container

---

## 🧠 Arquitetura do Projeto

```text
Git Push
   ↓
GitHub Actions
   ↓
Docker Build
   ↓
DockerHub Push
   ↓
SSH Connection (EC2)
   ↓
Docker Pull
   ↓
Container Restart
```

---

## 📂 Estrutura do Projeto

```text
Projeto-EC2-CICD/
│
├── app.py
├── Dockerfile
├── requirements.txt
└── .github/
    └── workflows/
        └── deploy.yml
```

---

## 💻 Aplicação Flask

### `app.py`

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello Docker + Flask + EC2 CI/CD!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
```

---

## 🐳 Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python","app.py"]
```

---

## 📦 requirements.txt

```txt
flask
```

---

## ⚙️ GitHub Actions Workflow

### `.github/workflows/deploy.yml`

```yaml
name: Docker Deploy

on:
  push:
    branches:
      - main

jobs:

  deploy:

    runs-on: ubuntu-latest

    steps:

      - name: Checkout code
        uses: actions/checkout@v4

      - name: Login DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker Image
        run: |
          docker build -t luisazevedo9/dockerhub-sshec2:latest .

      - name: Push DockerHub
        run: |
          docker push luisazevedo9/dockerhub-sshec2:latest

      - name: Deploy EC2
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ${{ secrets.EC2_USER }}
          key: ${{ secrets.EC2_SSH_KEY }}

          script: |

            docker pull luisazevedo9/dockerhub-sshec2:latest

            docker stop flaskapp || true
            docker rm flaskapp || true

            docker run -d \
              --name flaskapp \
              -p 5000:5000 \
              luisazevedo9/dockerhub-sshec2:latest
```

---

## 🔐 GitHub Secrets Configurados

No GitHub:

```text
Repository → Settings → Secrets and Variables → Actions
```

Secrets utilizados:

| Secret | Descrição |
|---------|------------|
| DOCKER_USERNAME | Username DockerHub |
| DOCKER_PASSWORD | Password / Access Token DockerHub |
| EC2_HOST | Public IPv4 da EC2 |
| EC2_USER | Utilizador SSH (`ubuntu`) |
| EC2_SSH_KEY | Chave SSH copiada da EC2 |

---

## ☁️ Configuração AWS EC2


Para este projeto foi criada uma **instância EC2 na AWS** com as seguintes características:

| Configuração | Valor |
|--------------|-------|
| Cloud Provider | AWS |
| Serviço | EC2 |
| Sistema Operativo | Ubuntu Server |
| Tipo de Instância | t2.micro |
| Região | eu-north-1 |
| Autenticação | SSH Key Pair |
| Acesso | Public IPv4 |

### Instalação Docker

```bash
sudo apt update
sudo apt install docker.io -y
```

---

### Ativar Docker

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

---

### Permissões Docker

```bash
sudo usermod -aG docker ubuntu
```


---

### Verificar Docker

```bash
docker ps
```

---

## 🔥 AWS Security Group

Inbound Rules configuradas:

| Type | Port | Source |
|------|------|------|
| SSH | 22 | My IP |
| Custom TCP | 5000 | Anywhere IPv4 |

---

## 🛠️ Comandos Utilizados

Build local:

```bash
docker build -t dockerhub-sshec2 .
```

Executar container:

```bash
docker run -d -p 5000:5000 dockerhub-sshec2
```

---

### Git Commands

```bash
git add .
git commit -m "ec2 cicd deploy"
git push origin main
```

---

## 🚀 Resultado Final

Após cada `git push`:

✔️ GitHub Actions executa automaticamente

✔️ Nova imagem Docker construída

✔️ Imagem enviada para DockerHub

✔️ SSH automático para AWS EC2

✔️ Container atualizado automaticamente

Aplicação acessível via browser:

```text
http://EC2_PUBLIC_IP:5000
```

Resultado:

```text
Hello Docker + Flask + EC2 CI/CD!
```
