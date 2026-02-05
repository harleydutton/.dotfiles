#!/usr/bin/env bash

echo "src: $1"
echo "dest: $2"

for file in "$1"/*; do
  if [[ "$file" == "." ]] || [[ "$file" == ".." ]] then
    continue
  fi
  find "$file" -type f -print0 | while read -r -d '' file; do
    mkdir -p "$2/$(dirname '$file')"
    ln -sf "$1/$file" "$2/$file"
  done
done










