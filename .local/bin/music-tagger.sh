#!/bin/bash

FILE="$1"
if ! opustags "$FILE" | grep -q '^fingerprint='; then
  TAG="$( fpcalc "$FILE" | grep 'FINGERPRINT=' | sed 's/FINGERPRINT=//')"
  opustags -i "$FILE" --add "fingerprint=$TAG"
fi
