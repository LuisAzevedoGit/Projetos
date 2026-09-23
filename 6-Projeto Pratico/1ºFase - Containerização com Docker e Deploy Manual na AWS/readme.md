# 🐳 Website Estático com Docker + Nginx → AWS (ECR + EC2)

Containerização de um website estático (HTML, CSS, JavaScript) com Docker e Nginx, com publicação da imagem no **Amazon ECR** e deploy numa instância **Amazon EC2**.

## 📌 Estado do projeto

| Fase | Descrição | Estado |
|---|---|---|
| 1 | Preparação do ambiente local | ✅ |
| 2 | Containerização com Docker e teste local | ✅ |
| 3 | Criação e configuração dos serviços AWS (ECR, IAM, EC2) | ✅ |
| 4 | Publicação da imagem no Amazon ECR | ✅ |
| 5 | Deploy manual na instância EC2 | ✅ |

## 🎯 Objetivos

- **Portabilidade** — o site funciona da mesma forma em qualquer ambiente.
- **Isolamento** — elimina o problema do "funciona na minha máquina".
- **Escalabilidade** — serve de base para arquiteturas mais complexas.
- **Padrão de indústria** — Docker é amplamente utilizado no mercado.

## 🏗️ Arquitetura

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Código Local   │────▶│  Docker Image   │────▶│   Amazon ECR    │
│  (HTML/CSS/JS)  │     │  (Container)    │     │   (Registry)    │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                           │
                                                           ▼
                        ┌─────────────────┐     ┌─────────────────┐
                        │     Browser     │◀────│   Amazon EC2    │
                        │  (User Access)  │     │  (Container)    │
                        └─────────────────┘     └─────────────────┘
```

## 🔧 Pré-requisitos

- [Docker](https://www.docker.com/products/docker-desktop) — `docker --version`
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) — `aws --version`
- Conta AWS (usar o Free Tier sempre que possível — alguns recursos geram custos)
- Editor de código (ex.: VS Code, com as extensões Docker e AWS Toolkit)

## 📁 Estrutura do projeto

```
meu-projeto/
├── website/
│   ├── index.html
│   ├── styles.css
│   ├── script.js
│   └── assets/
│       └── (imagens, fontes, etc.)
├── Dockerfile
└── README.md
```

> **Nota:** em todo este documento, `<CONTA_AWS>` e `<REGIAO>` representam o teu Account ID e a tua região AWS (ex.: `eu-north-1`).

---

## 1. Containerização local

### 1.1 Dockerfile

```dockerfile
# Imagem base - Nginx Alpine (leve e eficiente)
FROM nginx:alpine

# Copia os ficheiros do website para o diretório do Nginx
COPY website/ /usr/share/nginx/html/

# Expõe a porta 80 (documentação - não abre a porta realmente)
EXPOSE 80

# Comando padrão quando o container iniciar
CMD ["nginx", "-g", "daemon off;"]
```

| Instrução | Função |
|---|---|
| `FROM nginx:alpine` | Define a imagem base (Alpine é uma distro Linux muito leve) |
| `COPY` | Copia ficheiros do host para dentro da imagem |
| `EXPOSE` | Documenta a porta usada pelo container |
| `CMD` | Define o comando executado ao iniciar o container |

### 1.2 Construir a imagem

```bash
docker build -t meu-website:v1.0 .
docker images   # confirmar que a imagem foi criada
```

### 1.3 Executar o container

```bash
docker run -d -p 8081:80 --name meu-website-container meu-website:v1.0
```

| Opção | Significado |
|---|---|
| `-d` | Corre em background (detached) |
| `-p 8081:80` | Mapeia a porta 8081 do host para a porta 80 do container |
| `--name` | Nome atribuído ao container |

> A porta **8081** foi usada porque a 8080 já estava ocupada. Podes usar qualquer porta livre.

### 1.4 Testar

```bash
docker ps
```

Abrir no browser: **http://localhost:8081**

### 1.5 Parar e remover

```bash
docker stop meu-website-container
docker rm meu-website-container
```

### 1.6 Atualizar o website

Um container não reflete alterações feitas aos ficheiros depois de criado — usa a imagem tal como foi construída. Para atualizar, reconstrói a imagem e recria o container:

```bash
docker build -t meu-website:v1.0 . \
  && docker rm -f meu-website-container \
  && docker run -d -p 8081:80 --name meu-website-container meu-website:v1.0
```

### 1.7 Problemas comuns

| Erro | Causa | Solução |
|---|---|---|
| Container fica em `Exited (2)` | `CMD` com aspas simples ou `NGINX` em maiúsculas | Usar exatamente `CMD ["nginx", "-g", "daemon off;"]` |
| `port is already allocated` / `address already in use` | A porta já está a ser usada | Usar outra porta (`-p 8081:80`) ou identificar o processo: `sudo ss -tlnp \| grep 8080` |
| `container name is already in use` | Um container anterior (mesmo parado) mantém o nome | `docker rm meu-website-container` (ou `docker rm -f` para forçar) |
| Alterações ao site não aparecem | O container está a usar a imagem antiga | Repetir `docker build` e recriar o container |

Para diagnosticar um container que não arranca:

```bash
docker logs <nome-do-container>
```

---

## 2. Publicar a imagem no Amazon ECR

### 2.1 Criar o repositório ECR

1. Login na consola AWS.
2. Pesquisar por **ECR** → **Create repository**.
3. Atribuir um nome ao repositório (ex.: `meu-website`).
4. Manter as opções por defeito: **Mutable** e encriptação **AES-256**.
5. **Create** — o URI do repositório fica disponível e será usado mais à frente.

### 2.2 Configurar o AWS CLI

No terminal:

```bash
aws configure
```

Vai ser pedido:
- **Access Key ID** e **Secret Access Key** — obtidas em *AWS Console → nome da conta (canto superior direito) → Security credentials → Access keys*.
- **Região** — visível ao lado do nome da conta na consola.
- **Output format** — `json`.

Se o comando devolver `login succeeded` (ou equivalente), a configuração está correta.

### 2.3 Autenticar o Docker no ECR

```bash
aws ecr get-login-password --region <REGIAO> \
  | docker login --username AWS --password-stdin <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com
```

#### ⚠️ Erro comum: `pass not initialized`

```
error saving credentials: error storing credentials - err: exit status 1,
out: `pass not initialized: exit status 1: Error: password store is empty. Try "pass init".`
```

Isto acontece porque o Docker (no Linux) usa o `pass` como *credential helper* e ainda não existe nenhuma chave GPG nem *password store* configurados. Solução:

1. **Verificar se já existe uma chave GPG:**
   ```bash
   gpg --list-secret-keys
   ```
2. **Se não existir, criar uma nova chave:**
   ```bash
   gpg --full-generate-key
   ```
   - Tipo de chave: `(1) RSA and RSA`
   - Tamanho: `3072`
   - Validade: `0` (não expira)
   - Preencher nome e email quando pedido.
3. **Inicializar o password store** com o email usado na chave GPG:
   ```bash
   pass init "<teu-email>"
   ```
4. **Repetir o login no ECR** (comando da secção 2.3) — deve agora funcionar.

### 2.4 Etiquetar (tag) e publicar (push) a imagem

```bash
# Etiquetar a imagem local com o URI do ECR
docker tag meu-website:v1.0 <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com/meu-website:v1.0

# Publicar no ECR
docker push <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com/meu-website:v1.0
```

**Verificação:** no console AWS → ECR → repositório → a imagem deve aparecer com a tag `v1.0`.

---

## 3. Preparar a instância EC2

### 3.1 Criar o IAM Role para a EC2 aceder ao ECR

1. **IAM Console** → **Roles** → **Create role**.
2. Trusted entity: **AWS service**.
3. Use case: **EC2**.
4. Permissions: **AmazonEC2ContainerRegistryReadOnly**.
5. Nome do role: `EC2-ECR-Role`.

### 3.2 Lançar a instância EC2

**Console AWS → EC2 → Launch Instance**, com a seguinte configuração:

| Secção | Configuração |
|---|---|
| Nome | `meu-website-server` |
| AMI | Amazon Linux 2023 (Free tier eligible) |
| Instance type | `t2.micro` (Free tier eligible) |
| Par de chaves | Criar novo — nome `meu-website-key`, tipo RSA, formato `.pem` (Linux/Mac) |
| IAM Role | `EC2-ECR-Role` (criado no passo 3.1) |
| Rede | VPC default, subnet "no preference", IP público ativado |
| Security group | Criar novo — `meu-website-sg` |
| Armazenamento | 8 GiB gp3 (padrão) |

**Regras do Security Group:**

| Type | Protocol | Port Range | Source |
|---|---|---|---|
| SSH | TCP | 22 | My IP |
| HTTP | TCP | 80 | 0.0.0.0/0 |

⚠️ **Guarda o ficheiro `.pem` em local seguro** — é necessário para aceder à instância e não pode ser recuperado depois.

---

## 4. Deploy na EC2

### 4.1 Ligar à instância via SSH

```bash
# Ajustar permissões da chave (apenas necessário uma vez)
chmod 400 meu-website-key.pem

# Conectar via SSH
ssh -i meu-website-key.pem ec2-user@<IP_PUBLICO_EC2>
```

> Na primeira ligação, o SSH pergunta se confias no *host fingerprint* — responde `yes`.

### 4.2 Instalar e configurar o Docker na instância

```bash
# Atualizar pacotes
sudo yum update -y

# Instalar Docker
sudo yum install docker -y

# Iniciar o serviço Docker
sudo systemctl start docker

# Ativar o Docker no arranque
sudo systemctl enable docker

# Adicionar o utilizador ec2-user ao grupo docker
sudo usermod -a -G docker ec2-user

# Confirmar instalação
docker --version
```

### 4.3 Sair e voltar a entrar

Necessário para que a associação ao grupo `docker` tenha efeito:

```bash
exit
ssh -i meu-website-key.pem ec2-user@<IP_PUBLICO_EC2>
```

### 4.4 Autenticar o Docker com o ECR (dentro da EC2)

```bash
aws ecr get-login-password --region <REGIAO> \
  | docker login --username AWS --password-stdin <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com
```

> Isto funciona sem `aws configure` prévio graças às permissões do `EC2-ECR-Role` associado à instância.

### 4.5 Fazer pull da imagem

```bash
docker pull <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com/meu-website:v1.0
```

Saída esperada:
```
v1.0: Pulling from meu-website
Status: Downloaded newer image for <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com/meu-website:v1.0
```

### 4.6 Executar o container em produção

```bash
docker run -d -p 80:80 --name meu-website-prod --restart always \
  <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com/meu-website:v1.0
```

| Parâmetro | Função |
|---|---|
| `-p 80:80` | Mapeia a porta 80 (HTTP padrão) |
| `--restart always` | Reinicia o container automaticamente se a EC2 reiniciar |

### 4.7 Verificar

```bash
docker ps
docker logs meu-website-prod
```

---

## 5. Teste final

Abrir no browser o IP público da instância EC2:

```
http://<IP_PUBLICO_EC2>
```

O website deve estar visível. 🎉

---

## 6. 🧹 Limpeza de recursos

⚠️ **Importante:** para evitar custos, limpa os recursos depois de terminares o laboratório.

1. **Parar e remover o container na EC2:**
   ```bash
   docker stop meu-website-prod
   docker rm meu-website-prod
   docker rmi <CONTA_AWS>.dkr.ecr.<REGIAO>.amazonaws.com/meu-website:v1.0
   ```
2. **Terminar a instância EC2:** Console AWS → EC2 → selecionar a instância → *Actions → Instance State → Terminate*.
3. **Apagar a imagem no ECR:** Console AWS → ECR → repositório → selecionar a imagem → *Delete*.
4. **Apagar o repositório ECR** (opcional): selecionar o repositório → *Delete*.
5. **Apagar o Security Group:** EC2 → Security Groups → `meu-website-sg` → *Actions → Delete*.
6. **Apagar o IAM Role** (opcional): IAM → Roles → `EC2-ECR-Role` → *Delete*.