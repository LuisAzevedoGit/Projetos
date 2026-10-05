# ⚙️ GitHub Actions - Projeto 1 (Node CI)

## 📌 Objetivo

Criar o primeiro pipeline de **CI (Continuous Integration)** com **GitHub Actions** para um projeto Node.js.

O workflow executa automaticamente sempre que existe:

- Push para a branch `main`
- Pull Request para a branch `main`

---

## 🧠 O que foi feito

Foi criado um projeto Node.js simples com uma função de soma.

### `index.js`

```js
function soma(a, b) {
  return a + b;
}

module.exports = soma;
```

---

## 📂 Estrutura do Projeto

```text
Projeto-1-node/
│
├── index.js
├── package.json
└── .github/
    └── workflows/
        └── ci.yml
```

---

## ⚙️ Workflow GitHub Actions

### `.github/workflows/ci.yml`

```yaml
name: Node CI

on:
  push:
    branches:
      - main

  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Obter código
        uses: actions/checkout@v4

      - name: Instalar Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Instalar dependências
        run: npm install
```

---

## 🔎 Explicação do Workflow

### Trigger (`on`)

Define quando o pipeline deve correr.

```yaml
push:
pull_request:
```

Neste caso executa automaticamente em:

- Push para `main`
- Pull Requests para `main`

---

### Job

```yaml
jobs:
  test:
```

Cria um job chamado **test**.

---

### Runner

```yaml
runs-on: ubuntu-latest
```

Executa o workflow numa máquina virtual Ubuntu disponibilizada pelo GitHub.

---

### Checkout do código

```yaml
uses: actions/checkout@v4
```

Obtém o código do repositório.

---

### Instalar Node.js

```yaml
uses: actions/setup-node@v4
```

Instala Node.js versão 20.

---

### Instalar dependências

```yaml
run: npm install
```

Instala automaticamente as dependências do projeto.

---

## 🛠️ Comandos utilizados

Inicializar repositório Git:

```bash
git init
```

Adicionar ficheiros:

```bash
git add .
```

Criar commit:

```bash
git commit -m "primeiro projeto github actions"
```

Alterar branch para `main`:

```bash
git branch -M main
```

Adicionar repositório remoto:

```bash
git remote add origin https://github.com/USERNAME/REPOSITORIO.git
```

Enviar código para GitHub:

```bash
git push -u origin main
```

---

## 🚀 Resultado

Após o `git push`, o GitHub Actions executa automaticamente o pipeline.

Pode ser visualizado em:

**GitHub → Repository → Actions**

O workflow:

✔️ Obtém o código

✔️ Instala Node.js

✔️ Instala dependências do projeto

✔️ Finaliza com sucesso
