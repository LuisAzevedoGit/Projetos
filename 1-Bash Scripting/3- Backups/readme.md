# 💾 Linux Backup Automation with Rsync

## 📌 Objetivo

Automatizar backups locais em Linux utilizando Bash scripting e `rsync`.

O script:
- Cria diretórios automaticamente
- Faz backup da pasta `/home`
- Guarda logs do processo
- Remove ficheiros desnecessários
- Verifica erros automaticamente
- Mantém permissões originais dos ficheiros

---

# 🧠 Conceitos Aprendidos

- Bash scripting
- Linux backups
- Rsync
- Logs
- Permissões Linux
- Automação de tarefas
- Administração Linux
- Exit codes
- File synchronization

---

# 📂 Estrutura do Projeto

```bash
backup-project/
├── backups.sh
├── logs/
└── README.md
```

---

# 🧾 Código do Script

```bash
#!/bin/bash
# /usr/local/bin/rsync-local-backup.sh

# Configuration
SOURCE_DIR="/home"
BACKUP_DIR="/backup/home"
LOG_FILE="/var/log/backup/rsync-local.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Log backup start
echo "[$DATE] Starting local backup" >> "$LOG_FILE"

# Perform backup
rsync -av \
    --delete \
    --exclude='*.tmp' \
    --exclude='.cache' \
    --exclude='Downloads/*' \
    "$SOURCE_DIR/" \
    "$BACKUP_DIR/" \
    >> "$LOG_FILE" 2>&1

# Check exit status
if [ $? -eq 0 ]; then
    echo "[$DATE] Backup completed successfully" >> "$LOG_FILE"
    exit 0
else
    echo "[$DATE] Backup failed with errors" >> "$LOG_FILE"
    exit 1
fi
```

---

# ⚙️ Explicação do Código

## 📂 Variáveis de Configuração

```bash
SOURCE_DIR="/home"
BACKUP_DIR="/backup/home"
LOG_FILE="/var/log/backup/rsync-local.log"
```

Definem:
- pasta original
- destino do backup
- localização do log

---

## 📅 Data do Backup

```bash
DATE=$(date +"%Y-%m-%d %H:%M:%S")
```

Guarda data e hora atual.

Utilizado nos logs.

---

## 📁 Criar Diretórios

```bash
mkdir -p "$BACKUP_DIR"
```

Cria automaticamente a pasta de backup caso não exista.

---

```bash
mkdir -p "$(dirname "$LOG_FILE")"
```

Cria automaticamente a pasta dos logs.

---

## 📝 Iniciar Log

```bash
echo "[$DATE] Starting local backup" >> "$LOG_FILE"
```

Guarda no ficheiro de log:
- data
- hora
- início do backup

---

# 🔄 Backup com Rsync

## 🚀 Comando Principal

```bash
rsync -av
```

### Opções utilizadas

| Opção | Descrição |
|---|---|
| `-a` | Mantém permissões, grupos e ownership |
| `-v` | Mostra detalhes do processo |

---

## 🗑️ `--delete`

```bash
--delete
```

Remove ficheiros antigos do destino que já não existem na origem.

Mantém o backup sincronizado.

---

## 🚫 Exclusões

```bash
--exclude='*.tmp'
--exclude='.cache'
--exclude='Downloads/*'
```

Ignora:
- ficheiros temporários
- cache
- downloads

Evita backups desnecessários.

---

# 📝 Redirecionar Logs

```bash
>> "$LOG_FILE" 2>&1
```

Guarda:
- output normal
- erros

no ficheiro de log.

---

# ✅ Verificação de Erros

## 🔍 Verificar status do rsync

```bash
if [ $? -eq 0 ];
```

Verifica se o backup terminou corretamente.

---

## ✅ Backup com sucesso

```bash
echo "Backup completed successfully"
```

---

## ❌ Backup com erros

```bash
echo "Backup failed with errors"
```

---

# ▶️ Executar o Script

Dar permissões:

```bash
chmod +x backups.sh
```

Executar:

```bash
sudo ./backups.sh
```

---

# ⚠️ Porque é necessário sudo

O script precisa de permissões root para:
- criar `/backup`
- escrever em `/var/log`
- aceder a diretórios de outros utilizadores

Sem `sudo` podem aparecer erros como:

```bash
Permission denied
```

---

# 🔍 Verificar o Backup

## 📂 Verificar ficheiros copiados

```bash
cd /backup/home
ls
```

Exemplo:

```bash
ana.silva
devops
luis.azevedo
ricardo.araujo
```

---

## 🔐 Verificar permissões

```bash
ls -la /backup/home
```

O `rsync` mantém:
- permissões
- ownership
- grupos

---

## 👤 Aceder como root

```bash
sudo -i
```

Permite aceder a diretórios protegidos.

---

## 📝 Verificar logs

```bash
cat /var/log/backup/rsync-local.log
```

---

# 🚀 Melhorias Futuras

- Automatizar com cron
- Backups remotos via SSH
- Compressão automática
- Rotação de logs
- Retenção de backups
- Notificações por email
- Monitorização

---

# 📚 Tecnologias Utilizadas

- Ubuntu Server
- Bash
- Rsync
- Linux CLI
- File System
- Linux Permissions
- Logs
