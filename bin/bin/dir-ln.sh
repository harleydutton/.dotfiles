#!/usr/bin/env bash
while read -r file; do
  rel=$(dirname "${file#$1}")
  mkdir -p "$2$rel"
  ln -sf "$file" "$2${file#$1}"
done <<< $(find $1 -type f ! -wholename "*/.git/*")
