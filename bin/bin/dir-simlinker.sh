#!/usr/bin/env bash
cp -sf $1/. ~/temp
# -r = recursive, create directories for each file
# -s = create symlinks instead of copying
# -f = overwrite previously existing files/symlinks

#   # --- Configuration ---
#   # Directory where your dotfiles are stored
#   DOTFILES_DIR="$HOME/dotfiles"
#   # Target directory (usually home)
#   TARGET_DIR="$HOME"

#   # Colors for output
#   GREEN='\033[0;32m'
#   BLUE='\033[0;34m'
#   NC='\033[0m' # No Color

#   echo -e "${BLUE}Stowing dotfiles from $DOTFILES_DIR to $TARGET_DIR...${NC}"

#   # Change to the dotfiles directory
#   cd "$DOTFILES_DIR" || exit 1

#   # Iterate through all files/directories in the current folder
#   # Exclude the script itself and the .git directory
#   for item in * .[a-zA-Z0-9]*; do
#       # Skip non-existent items, current dir, parent dir, .git, and this script
#       if [[ "$item" == "*" || "$item" == "." || "$item" == ".." || "$item" == ".git" || "$item" == "stow-ish.sh" ]]; then
#           continue
#       fi

#       # Create target path
#       target="$TARGET_DIR/$item"

#       # If item is a directory (like .config or a named package folder)
#       if [ -d "$item" ]; then
#           # Recursively link contents
#           mkdir -p "$target"
#           
#           # This handles nested structure: dotfiles/pkg/folder/.file -> home/folder/.file
#           find "$item" -type f | while read -r subfile; do
#               relative_path="${subfile#$item/}"
#               # Create subdirectories if necessary
#               mkdir -p "$TARGET_DIR/$(dirname "$relative_path")"
#               
#               # Remove existing file/link and create new symlink
#               rm -rf "$TARGET_DIR/$relative_path"
#               ln -sf "$DOTFILES_DIR/$subfile" "$TARGET_DIR/$relative_path"
#               echo -e "Linked: ${GREEN}$subfile${NC} -> ${GREEN}$relative_path${NC}"
#           done
#       else
#           # Item is a file in the root of the dotfiles repo
#           rm -rf "$target"
#           ln -sf "$DOTFILES_DIR/$item" "$target"
#           echo -e "Linked: ${GREEN}$item${NC} -> ${GREEN}$target${NC}"
#       fi
#   done

#   echo -e "${BLUE}Done!${NC}"
