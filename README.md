## Setup Script

Prerecs: bash, git, ssh
untested: best to run line-by-line

``` bash
cd ~ \
git clone https://github.com/harleydutton/.dotfiles.git \
cd .dotfiles/bin/bin/ \
./dir-ln.sh ~/.dotfiles/bash/ ~/.bash \
./dir-ln.sh ~/.dotfiles/git/ ~/.git \
./dir-ln.sh ~/.dotfiles/ssh/ ~/.ssh \
./dir-ln.sh ~/.dotfiles/sway/ ~/.sway \
./dir-ln.sh ~/.dotfiles/vim/ ~/.vim \
./dir-ln.sh ~/.dotfiles/zsh/ ~/.zsh \
./dir-ln.sh ~/.dotfiles/bin/ ~/bin \
ssh-keygen.sh \
```
