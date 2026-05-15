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
