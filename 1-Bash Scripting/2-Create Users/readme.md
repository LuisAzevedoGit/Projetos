# 👥 Linux User Management Automation

## 📌 Objetivo

Automatizar a criação de utilizadores e grupos em Linux utilizando Bash scripting.

Neste projeto foram criadas duas abordagens:
- Criação manual de utilizadores
- Criação automática utilizando um ficheiro CSV

---

# 👤 Criação Manual de Utiladores

## 📄 Script Manual

```bash
#!/bin/bash

sudo useradd developer
sudo passwd developer

sudo groupadd developers
sudo usermod -aG developers developer
```

---

## ⚙️ O que este script faz

### 👤 Cria um utilizador

```bash
sudo useradd developer
```

Cria um novo utilizador chamado `developer`.

---

### 🔐 Define uma password

```bash
sudo passwd developer
```

Permite definir uma password para o utilizador.

---

### 👥 Cria um grupo

```bash
sudo groupadd developers
```

Cria um grupo chamado `developers`.

---

### ➕ Adiciona o utilizador ao grupo

```bash
sudo usermod -aG developers developer
```

Adiciona o utilizador `developer` ao grupo `developers`.

---

# 🤖 Criação Automática com CSV

## 📄 Script Automático

```bash
#!/bin/bash

CSV_FILE="users/list_users.csv"

# Ignora header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r USER PASSWORD GROUP
do

    echo "A processar utilizador: $USER"

    # Verifica se grupo existe
    if ! getent group "$GROUP" > /dev/null; then
        echo "Grupo $GROUP não existe. A criar..."
        groupadd "$GROUP"
    fi

    # Verifica se user existe
    if id "$USER" &>/dev/null; then
        echo "Utilizador $USER já existe."
    else
        echo "A criar utilizador $USER..."

        useradd -m -s /bin/bash "$USER"

        # Define password
        echo "$USER:$PASSWORD" | chpasswd

        # Adiciona ao grupo
        usermod -aG "$GROUP" "$USER"

        echo "Utilizador $USER criado com sucesso."
    fi

    echo "---------------------------"

done
```

---

# 🧠 Explicação Simples do Código

## 📂 Definir o ficheiro CSV

```bash
CSV_FILE="users/list_users.csv"
```

Indica onde está guardada a lista de utilizadores.

---

## 📥 Ler o ficheiro CSV

```bash
tail -n +2 "$CSV_FILE"
```

Ignora a primeira linha do ficheiro.

Normalmente a primeira linha contém os nomes das colunas.

---

## 🔄 Ler cada linha

```bash
while IFS=',' read -r USER PASSWORD GROUP
```

Lê cada linha do CSV e separa os valores por vírgulas.

Exemplo:

```csv
joao.oliveira,joao123,developer
```

Fica dividido em:
- USER → joao.oliveira
- PASSWORD → joao123
- GROUP → developer

---

## 👥 Verificar se o grupo existe

```bash
if ! getent group "$GROUP" > /dev/null;
```

Verifica se o grupo já existe no sistema.

Se não existir:
- cria automaticamente o grupo

```bash
groupadd "$GROUP"
```

---

## 👤 Verificar se o utilizador existe

```bash
if id "$USER" &>/dev/null;
```

Verifica se o utilizador já foi criado anteriormente.

Se existir:
- o script ignora o utilizador

Se não existir:
- cria automaticamente

---

## 🏠 Criar utilizador

```bash
useradd -m -s /bin/bash "$USER"
```

Cria:
- utilizador
- home directory
- shell Bash

---

## 🔐 Definir password

```bash
echo "$USER:$PASSWORD" | chpasswd
```

Define automaticamente a password do utilizador.

---

## ➕ Adicionar utilizador ao grupo

```bash
usermod -aG "$GROUP" "$USER"
```

Adiciona o utilizador ao grupo definido no CSV.

---

# 📄 Ficheiro CSV

```csv
joao.oliveira,joao123,developer
ana.silva,ana123,tester
luis.azevedo,luis123,devops_group
ricardo.araujo,ricardo123,tester
```

Cada linha representa:
- username
- password
- grupo

---

# 🔍 Comandos de Verificação

## 👥 Verificar grupos

```bash
getent group tester
```

Resultado:

```bash
tester:x:1003:ana.silva,ricardo.araujo
```

Mostra:
- nome do grupo
- ID do grupo
- utilizadores associados

---

## 👤 Verificar utilizador

```bash
id luis.azevedo
```

Resultado:

```bash
uid=1003(luis.azevedo) gid=1005(luis.azevedo) groups=1005(luis.azevedo),1000(devops)
```

Mostra:
- UID
- GID
- grupos associados

---

## 👤 Outro exemplo

```bash
id ana.silva
```

Resultado:

```bash
uid=1002(ana.silva) gid=1004(ana.silva) groups=1004(ana.silva),1003(tester)
```

---

## 📋 Listar todos os utilizadores

```bash
cut -d: -f1 /etc/passwd
```

Mostra todos os utilizadores existentes no sistema.

---

## 👥 Listar todos os grupos

```bash
cut -d: -f1 /etc/group
```

Mostra todos os grupos existentes no sistema.

---

# ▶️ Executar o Script

Dar permissões:

```bash
chmod +x create_users.sh
```

Executar:

```bash
sudo ./create_users.sh
```

---

# 🚀 Conceitos Aprendidos

- Bash scripting
- Linux users
- Linux groups
- CSV parsing
- Automação Linux
- Gestão de permissões
- Administração de sistemas
