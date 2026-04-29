#!/bin/bash
# UPLOAD NEW MUSIC
mkdir -p ~/Downloads/new-music
rclone copy ~/Downloads/new-music gdrive:Music
if [ $? -eq 0 ]; then
    rm -f ~/Downloads/new-music/*
    rclone dedupe --dedupe-mode newest gdrive:Music
else
    echo "Aborting: Failed to upload all files!"
    exit 1
fi

# TWO WAY SYNC
#   set -e
#   LEDGER_DIR="$HOME/.cache/rclone/bisync"
#   if ! ls "$LEDGER_DIR"/gdrive_Music* &>/dev/null; then
#       rclone bisync gdrive:Music ~/Music --resync
#   else
#       rclone bisync gdrive:Music ~/Music
#   fi

# CREATE SNAPSHOT
#   LATEST_SNAPSHOT=$(rclone lsd gdrive:Music-Snapshots/ 2>/dev/null | awk '{print $NF}' | sort | tail -1)
#   THIRTY_DAYS_AGO=$(date -d "30 days ago" +%Y-%m-%d)

#   if [[ -z "$LATEST_SNAPSHOT" || "$LATEST_SNAPSHOT" < "$THIRTY_DAYS_AGO" ]]; then
#       echo "Taking snapshot..."
#       rclone copy gdrive:Music gdrive:Music-Snapshots/$(date +%Y-%m-%d)
#   fi
