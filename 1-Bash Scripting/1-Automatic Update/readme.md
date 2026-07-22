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



---

### 🚀 `apt full-upgrade -y`

Executa upgrades completos incluindo dependências.


---

### 🧹 `apt autoremove -y`

Remove dependências e pacotes antigos.


---

### 🗑️ `apt clean`

Limpa ficheiros temporários da cache do apt.


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

---
