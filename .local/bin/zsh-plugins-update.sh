#!/usr/bin/bash
# intended to be used with weekly chrontab or at login


for folder in ~/.zsh_plugins/*/; do
if [[ -d "$folder/.git" ]]; then
  git -C "$folder" pull --ff-only
fi
done
