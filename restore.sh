#!/bin/bash

# ============================================
# HOSPITAL DATABASE RESTORE SCRIPT
# ============================================

DB_NAME="hospital_management"
DB_USER="aidai"
BACKUP_DIR="$HOME/hospital_project/backups"

echo "Available backups:"
ls -lh "$BACKUP_DIR"/*.gz 2>/dev/null || echo "No backups found!"

echo ""
echo "Enter backup filename to restore (or press Enter for latest):"
read BACKUP_CHOICE

if [ -z "$BACKUP_CHOICE" ]; then
    BACKUP_CHOICE=$(ls -t "$BACKUP_DIR"/*.gz 2>/dev/null | head -1)
fi

if [ -z "$BACKUP_CHOICE" ]; then
    echo "No backup file found!"
    exit 1
fi

echo "Restoring from: $BACKUP_CHOICE"
echo "WARNING: This will overwrite current database! Continue? (y/n)"
read CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Restore cancelled."
    exit 0
fi

# Decompress and restore
gunzip -c "$BACKUP_CHOICE" | psql -U $DB_USER -d $DB_NAME

if [ $? -eq 0 ]; then
    echo "Restore successful!"
else
    echo "Restore failed!"
fi
