#!/usr/bin/env bash
while read -r file; do
  mkdir -p $2$(dirname "${file#$1}")
  ln -sf "$file" "$2${file#$1}"
done <<< $(find $1 -type f -regextype posix-extended ! -regex "$3")
