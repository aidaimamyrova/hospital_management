#!/bin/bash

# ============================================
# HOSPITAL DATABASE BACKUP SCRIPT
# ============================================

DB_NAME="hospital_management"
DB_USER="aidai"
BACKUP_DIR="$HOME/hospital_project/backups"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/hospital_backup_$TIMESTAMP.sql"

# Create backup folder if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Starting backup of $DB_NAME..."
echo "Backup file: $BACKUP_FILE"

# Perform the backup
pg_dump -U $DB_USER -d $DB_NAME > "$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful!"
    echo "File size: $(du -h "$BACKUP_FILE" | cut -f1)"
else
    echo "Backup failed!"
    exit 1
fi

# Compress the backup
gzip "$BACKUP_FILE"
echo "Backup compressed: ${BACKUP_FILE}.gz"

# Keep only last 7 backups
ls -t "$BACKUP_DIR"/*.gz 2>/dev/null | tail -n +8 | xargs rm -f 2>/dev/null

echo "Done! Backups kept:"
ls -lh "$BACKUP_DIR"
