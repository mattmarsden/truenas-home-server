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

echo "Monitoring /media/downloads/complete/ for MOVED_TO/CREATE/MODIFY events..."

inotifywait -m /media/downloads/complete/ -e MOVED_TO -e CREATE -e MODIFY --exclude '/[.@]' \
| while read -r DIR OPERATION FILE; do
    echo "[INOTIFY] DIRECTORY=$DIR EVENT=$OPERATION FILE=$FILE"

    SRC="$DIR$FILE"
    DEST="/media/downloads/scanned/"
    QUARANTINE_DIR="/media/downloads/quarantine/"
    echo "Scanning:"

    SCAN_RESULTS=$(clamscan -r "$SRC" --move="$QUARANTINE_DIR")
    echo "$SCAN_RESULTS"

    # Scan and move infected files to quarantine
    if echo "$SCAN_RESULTS" | grep -q "Infected files: 0"; then
      echo "No threats found. Moving from '$SRC' to '$DEST' folder."
      mv "$SRC" "$DEST"
      echo "Moved successfully"
    else
      echo "Threat detected. Moved to '$QUARANTINE_DIR'."
    fi
  done
