#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

SOURCE_DIR="devops@192.168.56.101:/home/devops"
BACKUP_DIR="/home/devops/backups/$DATE"
LOG_DIR="/home/devops/backups/logs"
LOG_FILE="$LOG_DIR/rsync-local.log"

START_TIME=$(date +%s)

mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Starting remote backup" >> "$LOG_FILE"


export HOME=/home/devops

/usr/bin/rsync -avz \
    -e ssh \
    --delete \
    --exclude='*.tmp' \
    --exclude='.cache' \
    --exclude='Downloads/*' \
    "$SOURCE_DIR/" \
    "$BACKUP_DIR/" \
    >> "$LOG_FILE" 2>&1

STATUS=$?

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

if [ $STATUS -eq 0 ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup completed successfully" >> "$LOG_FILE"
else
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup failed with errors" >> "$LOG_FILE"
fi

echo "Backup completed in ${DURATION} seconds" >> "$LOG_FILE"

exit $STATUS
