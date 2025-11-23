#!/bin/sh
set -eu

# Start freshclam in daemon mode
echo "Starting freshclam update daemon..."
freshclam -d &

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
    DEST="/media/downloads/scanned/"
    echo "Scanning: $SRC"

    # Scan and move infected files to quarantine
    if clamscan "$SRC" --move=/media/downloads/quarantine/ | grep -q "Infected files: 0"; then
      echo "No threats found in '$SRC'. Moving to '$DEST' folder."
      mv "$SRC" "$DEST"
    fi
  done
