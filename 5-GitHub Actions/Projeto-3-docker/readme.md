# 🐳 Docker + GitHub Actions - Projeto 2 (Docker CI)

## 📌 Objetivo

Criar um projeto simples com **Docker + GitHub Actions** para automatizar o processo de **build e teste de containers**.

O pipeline executa automaticamente sempre que existe um **push para a branch `main`**.

---

## 🧠 O que foi feito

Foi criada uma pequena aplicação **Node.js + Express** que responde com uma mensagem simples.

Depois, a aplicação foi dockerizada utilizando um **Dockerfile**.

Por fim, foi criado um workflow **GitHub Actions** responsável por:

- Obter o código do repositório
- Construir a imagem Docker
- Executar o container automaticamente

---

## 📂 Estrutura do Projeto

```text
Projeto-3-docker/
│
├── app.js
├── package.json
├── Dockerfile
└── .github/
    └── workflows/
        └── ci.yml
```

---

## 💻 Código da Aplicação

### `app.js`

```js
const express = require('express');

const app = express();

app.get('/', (req,res)=>{
    res.send("Docker CI/CD Project");
});

app.listen(3000, ()=>{
    console.log("Server running on port 3000");
});
```

---

## 🐳 Dockerfile

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node","app.js"]
```

---

## 🔎 Explicação do Dockerfile

### Imagem base

```dockerfile
FROM node:20-alpine
```

Utiliza Node.js 20 numa versão Alpine Linux (imagem leve e rápida).

---

### Diretório de trabalho

```dockerfile
WORKDIR /app
```

Define `/app` como diretório principal dentro do container.

---

### Copiar dependências

```dockerfile
COPY package*.json ./
```

Copia os ficheiros `package.json`.

---

### Instalar dependências

```dockerfile
RUN npm install
```

Instala automaticamente as dependências Node.js.

---

### Copiar código da aplicação

```dockerfile
COPY . .
```

Copia todos os ficheiros do projeto para dentro do container.

---

### Expor porta

```dockerfile
EXPOSE 3000
```

Expõe a porta 3000.

---

### Executar aplicação

```dockerfile
CMD ["node","app.js"]
```

Inicia o servidor Node.js.

---

## ⚙️ GitHub Actions Workflow

### `.github/workflows/ci.yml`

```yaml
name: Docker CI

on:

  push:
    branches:
      - main

jobs:

  docker:

    runs-on: ubuntu-latest

    steps:

      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t docker-ci-app .

      - name: Run container test
        run: |
          docker run -d -p 3000:3000 --name app docker-ci-app
```

---

## 🔎 Explicação do Workflow

### Trigger

```yaml
on:
  push:
```

Executa automaticamente sempre que existe um push na branch `main`.

---

### Checkout do código

```yaml
uses: actions/checkout@v4
```

Obtém o código do repositório.

---

### Build da imagem Docker

```yaml
docker build -t docker-ci-app .
```

Cria a imagem Docker da aplicação.

---

### Executar container

```yaml
docker run -d -p 3000:3000 --name app docker-ci-app
```

Inicia o container em background.

---

## 🛠️ Comandos Utilizados

Construir imagem localmente:

```bash
docker build -t docker-ci-app .
```

Executar container:

```bash
docker run -d -p 3000:3000 docker-ci-app
```

Verificar containers ativos:

```bash
docker ps
```

---

### Git Commands

Adicionar ficheiros:

```bash
git add .
```

Criar commit:

```bash
git commit -m "docker ci project"
```

Enviar código:

```bash
git push
```

---

## 🚀 Resultado

Após o `git push`, o GitHub Actions executa automaticamente:

✔️ Checkout do código

✔️ Build da imagem Docker

✔️ Criação do container

✔️ Pipeline executado com sucesso

Pode ser visualizado em:

**GitHub → Repository → Actions**
