#!/bin/sh

echo "Starting backup script..."

# The directory within the container where backups will be stored.
BACKUP_DIR="/backup"

# Fetch current date and time for the backup folder name.
DATE=$(date +"%Y%m%d-%H%M")

# Create a timestamped directory for this backup.
BACKUP_DIR_WITH_TIMESTAMP="$BACKUP_DIR/$DATE"
mkdir -p "$BACKUP_DIR_WITH_TIMESTAMP"

echo "Backup directory: $BACKUP_DIR_WITH_TIMESTAMP"

# Use lftp to mirror files from the FTP server to the local backup directory.
lftp -c "open -u $FTP_USERNAME,$FTP_PASSWORD $FTP_SERVER; mirror / /backup/$DATE"

echo "Backup complete."

# Limit the number of backups to 50.
# This will count the number of directories in $BACKUP_DIR, and if this number exceeds 50,
# it will delete the oldest ones.
cd $BACKUP_DIR
BACKUP_COUNT=$(ls -1 | wc -l)
MAX_BACKUPS=20

echo "Backup count: $BACKUP_COUNT"

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    # This finds the oldest files and directories and deletes them so that only $MAX_BACKUPS remain.
    ls -t | tail -n +$(($MAX_BACKUPS+1)) | xargs rm -rf
fi

echo "Backup script complete."
