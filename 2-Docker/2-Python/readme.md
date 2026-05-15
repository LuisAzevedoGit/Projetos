# 🐳 Docker Project 2 — Python Script with CSV Processing

## 📌 Objetivo

Neste projeto foi criada a conteinerização de um script Python que processa dados de um ficheiro CSV utilizando a biblioteca **pandas**.

O objetivo foi aprender:
- executar scripts Python em Docker
- gerir dependências com `requirements.txt`
- trabalhar com volumes no Docker
- tornar scripts portáveis

---

# 📁 Estrutura do Projeto

```text
2-python/
│
├── process_data.py
├── requirements.txt
├── Dockerfile
└── data.csv
🐍 Script Python (process_data.py)
import pandas as pd

# Lê o arquivo CSV
df = pd.read_csv("data.csv")

# Conta o número total de linhas
total_linhas = len(df)
print(f"Total de linhas: {total_linhas}")

# Filtra linhas que contêm a palavra "erro"
linhas_com_erro = df[
    df.astype(str).apply(
        lambda linha: linha.str.contains("erro", case=False, na=False).any(),
        axis=1
    )
]

# Mostra as linhas encontradas
print("\nLinhas que contêm a palavra 'erro':")
print(linhas_com_erro)
📦 requirements.txt
pandas
🐳 Dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["python", "process_data.py"]
🧠 Explicação do Dockerfile
🔹 FROM python:3.9-slim

Usa uma imagem leve de Python.

🔹 WORKDIR /app

Define o diretório de trabalho dentro do container.

🔹 COPY requirements.txt

Copia dependências para o container.

🔹 RUN pip install

Instala as dependências (pandas).

🔹 COPY . .

Copia todo o projeto para dentro do container.

🔹 CMD

Executa o script Python automaticamente.

🏗️ Build da Imagem
docker build -t python-script .
🚀 Executar o Container
docker run -v $(pwd)/data:/app/data python-script
🧠 Explicação do comando
🔹 -v (volume)

Permite ligar uma pasta local ao container:

$(pwd)/data → /app/data

👉 isto permite que o container aceda ao ficheiro CSV local

📊 Exemplo de Output
Total de linhas: 6

Linhas que contêm a palavra 'erro':
                   Olá
1     erro no download
4       erro no upload
5  erro failed to open
🧠 Conceitos Aprendidos
Docker com Python
gestão de dependências (pip + requirements.txt)
volumes no Docker
execução de scripts em container
processamento de ficheiros CSV com pandas
🚀 Resultado Final

Foi criado com sucesso:

um container Python funcional
processamento automático de CSV
filtragem de dados dentro de Docker
uso de volumes para dados externos
