# 🔄 Ubuntu Update Script

## 📌 Objetivo

Automatizar atualizações do sistema Ubuntu Server utilizando Bash scripting.

O script:
- Atualiza repositórios
- Atualiza pacotes instalados
- Executa full upgrade
- Remove dependências antigas
- Limpa cache do apt

---

## 📂 Localização

```bash
~/scripts/update.sh
```

---

## 🧾 Código do Script

```bash
#!/bin/bash

echo "Starting system update"

sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt clean

echo "System updated with success"
```

---

## ⚙️ Explicação dos Comandos

### 📥 `apt update`

Atualiza a lista de pacotes disponíveis nos repositórios.

```bash
sudo apt update
```

---

### ⬆️ `apt upgrade -y`

Atualiza pacotes instalados sem pedir confirmação.

```bash
sudo apt upgrade -y
```

👉 `-y` aceita automaticamente as confirmações.

---

### 🚀 `apt full-upgrade -y`

Executa upgrades completos incluindo dependências.

```bash
sudo apt full-upgrade -y
```

---

### 🧹 `apt autoremove -y`

Remove dependências e pacotes antigos.

```bash
sudo apt autoremove -y
```

---

### 🗑️ `apt clean`

Limpa ficheiros temporários da cache do apt.

```bash
sudo apt clean
```

---

## 🔐 Permissões de Execução

Inicialmente o script não tinha permissões de execução.

Erro:

```bash
Permission denied
```

Resolução:

```bash
chmod +x update.sh
```

---

## ▶️ Executar o Script

```bash
./update.sh
```

ou

```bash
sudo ./update.sh
```

---
