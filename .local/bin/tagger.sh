#!/bin/bash
FILE="$1"
TAG="$( fpcalc "$FILE" | grep 'FINGERPRINT=' | sed 's/FINGERPRINT=//')"
ffmpeg -i "$FILE" -metadata fingerprint="$TAG" -c copy "#$FILE"
mv "#$FILE" "$FILE"
ffprobe -hide_banner "$FILE"

