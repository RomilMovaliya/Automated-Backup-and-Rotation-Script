#!/bin/bash

# Variables
GITHUB_REPOSITORY="https://github.com/RomilMovaliya/DemoPractical.git"

DIRECTORY_OF_PROJECT="$1" # that shows Project directory path (Here We Passed as an argument)

DIRECTORY_OF_BACKUP="$2"  # that shows Backup directory path (This is a directory Where backups will be stored)

NAME_OF_THE_BACKUP="backup_$(date +'%Y-%m-%d_%H-%M-%S').zip" #Here backup name start like "backup_" with date in yyyy-mm-dd hour-minute-second and with.zip extension

#Here we are defining Retention period
RETENTION_DAYS=7   # To keeping the number of daily backups.
RETENTION_WEEKS=4  # To keeping the number of weekly backups.
RETENTION_MONTHS=3 # To keeping the number of monthly backups.

LOG_FILE="$DIRECTORY_OF_BACKUP/backup.log"
WEBHOOK_URL="https://webhook.site/a5d27956-9dbc-4381-9af4-f844032beb07" # Just copy Webhook URL from Webhoook.site for notifications

#It is curl status which is enabled by default.
CURL_STATUS_ENABLED=${3:-true}

# Now we Create a backup directory if it is does not exist
mkdir -p "$DIRECTORY_OF_BACKUP"

# Here we are Cloning FROM GitHub repository TO DIRECTORY_OF_PROJECT
git clone "$GITHUB_REPOSITORY" "$DIRECTORY_OF_PROJECT"

# Create a backup
zip -r "$DIRECTORY_OF_BACKUP/$NAME_OF_THE_BACKUP" "$DIRECTORY_OF_PROJECT"

# when our backup file is created then it print the Log of backup and store it in logfile.
echo "$(date): Created backup $NAME_OF_THE_BACKUP" >> "$LOG_FILE"

# Here we are Integrating with Google Drive 
GDRIVE_REMOTE="gdrive_backup" # It is Name of rclone remote 
GDRIVE_FOLDER="BackupFolder"  # It is Name of google drive folder

# Push the backup to Google Drive
rclone copy "$DIRECTORY_OF_BACKUP/$NAME_OF_THE_BACKUP" "$GDRIVE_REMOTE:$GDRIVE_FOLDER"

# Here we are printing Log when our backup file is uploaded on google drive.
echo "$(date): Uploaded backup $NAME_OF_THE_BACKUP to Google Drive" >> "$LOG_FILE"

# Retention function
rotate_backups() {
    # It Delete backups older than 'x' days
    find "$DIRECTORY_OF_BACKUP" -type f -name "*.zip" -mtime +$RETENTION_DAYS -exec rm {} \;
    
    # It Keeps last 4 weekly backups (e.g., last 4 Sundays)
    find "$DIRECTORY_OF_BACKUP" -type f -name "*.zip" -exec bash -c '(( $(date -d $(basename {} .zip | cut -d"_" -f2) +%u) == 7 ))' \;

    # It Keeps last 3 monthly backups (e.g., first of each month)
    find "$DIRECTORY_OF_BACKUP" -type f -name "*.zip" -exec bash -c '(( $(date -d $(basename {} .zip | cut -d"_" -f2) +%d) == 1 ))' \;

    echo "$(date): Rotated backups" >> "$LOG_FILE"
}

rotate_backups



curl_status_func(){
curl -X POST -H "Content-Type: application/json" \
    -d '{"project": "'"ROMILBHAI'S PROJECT"'", "date": "'"$(date)"'", "test": "BackupSuccessful"}' \
    "$WEBHOOK_URL"
}


if [ "$CURL_STATUS_ENABLED" = "true" ]; then
    curl_status_func
else
    echo "cURL notification is disabled, so no notification will be sent." >> "$LOG_FILE"
fi
