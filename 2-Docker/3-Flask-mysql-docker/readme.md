# 🐳 Projeto 3 — Flask + MySQL com Docker Compose

## 📌 Objetivo

Criar uma aplicação Flask ligada a uma base de dados MySQL utilizando Docker Compose para gerir múltiplos containers.

Este projeto teve como objetivo aprender:
- Docker Compose
- Comunicação entre containers
- Flask em Docker
- MySQL em Docker
- Persistência de dados com volumes

---

## ⚙️ Tecnologias Utilizadas

- Docker
- Docker Compose
- Flask
- MySQL
- Python

---

## 📁 Estrutura do Projeto

```text
project/
│
├── app.py
├── docker-compose.yml
├── Dockerfile
└── requirements.txt
```


## 🐍 Código Flask
📄 app.py
```python
from flask import Flask
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    connection = mysql.connector.connect(
        host="db",
        user="root",
        password="example",
        database="test_db"
    )
    return connection

@app.route('/')
def hello_world():
    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("SELECT 'Hello, Docker + Flask + MySQL!'")

    result = cursor.fetchone()

    connection.close()

    return str(result[0])

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
```

## 📦 requirements.txt
flask
mysql-connector-python
## 🐳 Dockerfile
```docker
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python","app.py"]
```
## 🧱 Docker Compose
📄 docker-compose.yml
```yml
version: "3.8"

services:

  db:
    image: mysql:5.7
    container_name: mysql-db
    restart: always

    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: test_db

    ports:
      - "3306:3306"

    volumes:
      - db_data:/var/lib/mysql

  web:
    build: .
    container_name: flask-app

    ports:
      - "5000:5000"

    depends_on:
      - db

    volumes:
      - .:/app

    environment:
      FLASK_ENV: development

volumes:
  db_data:
```
## 🚀 Build e Execução
Construir e iniciar os containers: docker compose up --build
## 🌍 Aceder à Aplicação

Abrir no navegador:

http://localhost:5000

Resultado esperado:

Hello, Docker + Flask + MySQL!
## 🔍 Comandos Utilizados
Ver containers ativos: docker ps

Ver logs: docker compose logs

Parar containers: docker compose down

## 📌 Conceitos Importantes
Docker Compose

Permite executar múltiplos containers com um único comando.

Comunicação entre containers

O Flask comunica com o MySQL utilizando:

host="db"

O nome db corresponde ao nome do serviço definido no docker-compose.yml.

Volumes

O volume:

db_data:/var/lib/mysql

permite guardar os dados do MySQL mesmo que o container seja removido.
