#!/usr/bin/env bash

for top in "$1"/*; do
  if [[ "$top" == "." ]] || [[ "$top" == ".." ]] || [[ "$top" == ".git" ]] then
    continue
  fi
  find "$top" -type f | while read -r file; do
    rel=$(dirname "$file")
    mkdir -p "$2${rel#$top}"
    ln -sf "$file" "$2${file#$top}"
  done
done










