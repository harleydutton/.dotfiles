#!/bin/bash
FILE="$1"

# plan is to pull out ytid and save it in the metadata so I can rename the files
# other part of the plan is to use ytdlp and the ytid to get better metadata so I know what to rename them to
YT_ID="$(echo "$FILE" | sed 's/.*\[\([^]]*\)\].*/\1/')"

# attach fingerprint
TAG="$( fpcalc "$FILE" | grep 'FINGERPRINT=' | sed 's/FINGERPRINT=//')"
ffmpeg -i "$FILE" -metadata fingerprint="$TAG" -c copy "#$FILE"
mv "#$FILE" "$FILE"
ffprobe -hide_banner "$FILE"



