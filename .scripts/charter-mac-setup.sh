(cd $(dirname $0)
./git-ssh-setup.sh
./dotfile-repo-setup.sh
./install-commentary.sh
./install-zsh-plugins.sh
./install-homebrew.sh
brew install maven keychain 
)
