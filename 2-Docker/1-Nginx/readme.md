# 🐳 Docker Project 1 — Nginx Web Server

## 📌 Objetivo

Criar um container Docker com um servidor web simples utilizando Nginx.

Neste projeto aprendi:
- criar imagens Docker
- executar containers
- expor portas
- servir uma página HTML através do Nginx

---

# 📁 Estrutura do Projeto

```text
1-nginx/
│
├── Dockerfile
└── index.html
🌐 index.html
<title>Meu primeiro Docker</title>

Hello Docker + Nginx!

This is my first docker container.
🐳 Dockerfile
FROM nginx:alpine

COPY ./index.html /usr/share/nginx/html/index.html

EXPOSE 80
🧠 Explicação do Dockerfile
🔹 FROM nginx:alpine

Utiliza a imagem oficial do Nginx baseada em Alpine Linux.

🔹 COPY

Copia o ficheiro index.html para dentro do container.

🔹 EXPOSE 80

Expõe a porta 80 do servidor Nginx.

🏗️ Build da Imagem
docker build -t my-nginx-app .
🚀 Executar o Container
docker run -d -p 8080:80 my-nginx-app
🧠 Explicação
🔹 -d

Executa o container em background.

🔹 -p 8080:80

Mapeamento de portas:

PORTA_LOCAL:PORTA_CONTAINER
porta 8080 da máquina
→ porta 80 do container
📋 Verificar Containers
docker ps
🌍 Aceder à Aplicação
http://localhost:8080

Ou:

http://IP_DA_VM:8080
🔍 Teste via Terminal
curl localhost:8080
🛠️ Comandos Úteis
Ver logs
docker logs <container_id>
Entrar no container
docker exec -it <container_id> sh
Parar container
docker stop <container_id>
Remover container
docker rm <container_id>
✅ Resultado Final

Foi criado com sucesso:

um container Docker
um servidor Nginx funcional
uma página HTML servida através do Docker


# 📋 Container em Execução

| CONTAINER ID | IMAGE | COMMAND | CREATED | STATUS | PORTS | NAMES |
|---|---|---|---|---|---|---|
| 8bfc6a70397b | my-nginx-app | "/docker-entrypoint.…" | 5 seconds ago | Up 3 seconds | 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp | hardcore_solomon |
