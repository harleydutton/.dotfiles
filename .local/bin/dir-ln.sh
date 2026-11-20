#!/usr/bin/env bash
# usage: dir-ln.sh [SOURCE=~/.dotfiles] [DESTINATION=~] [EXCLUDE_REGEX='.*(/\.git/|README\.md|root).*']  (symlinks every file in SOURCE into DESTINATION)
src=$(realpath "${1:-$HOME/.dotfiles}")
dst=$(realpath -m "${2:-$HOME}")
skip=${3:-'.*(/\.git/|README\.md|root).*'}
while read -r file; do
  mkdir -p "$dst$(dirname "${file#$src}")"
  ln -sf "$file" "$dst${file#$src}"
done <<< $(find "$src" -type f -regextype posix-extended ! -regex "$skip")
