cd ~/.dotfiles
stow bash
stow git
stow ssh
stow sway
stow vim
stow zsh
stow bin

#   needs the stow utility installed
#   when run, overwrites the contents of each folder to it's location in home

# untested alternative that uses symlinks
#   cp -rsf "$dotfiles_home"/. ~
#       -r: Recursive, create the necessary directory for each file
#       -s: Create symlinks instead of copying
#       -f: Overwrite existing files (previously created symlinks, default .bashrc, etc)
#       /.: Make sure cp "copy" the contents of home instead of the home directory itself.

