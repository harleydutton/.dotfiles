#!/bin/bash

FILE="$1"
if ! opustags "$FILE" | grep -q '^fingerprint='; then
  TAG="$( fpcalc "$FILE" | grep 'FINGERPRINT=' | sed 's/FINGERPRINT=//')"
  opustags -i "$FILE" --add "fingerprint=$TAG"
  echo "tagging:  $1"
else
  echo "skipping: $1"
fi
