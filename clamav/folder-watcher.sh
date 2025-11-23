#!/bin/sh
set -eu

# Ensure required directories exist
mkdir -p \
  /media/downloads/complete \
  /media/downloads/incomplete \
  /media/downloads/scanned \
  /media/downloads/quarantine

echo "Monitoring /media/downloads/complete/ for MOVED_TO events..."

inotifywait -m /media/downloads/complete/ -e MOVED_TO --exclude '/[.@]' \
| while read -r FOLDER OPERATION FILE; do
    echo "[INOTIFY] FOLDER=$FOLDER OPERATION=$OPERATION FILE=$FILE"

    SRC="$FOLDER$FILE"
    echo "Going to scan: $SRC"
    echo "First, updating virus database..."
    freshclam

    # Scan and move infected files to quarantine
    if clamscan "$SRC" --move=/media/downloads/quarantine/ | grep -q "Infected files: 0"; then
      echo "No threats found in $SRC. Moving to scanned folder."
      mv "$SRC" /media/downloads/scanned/
    fi
  done
