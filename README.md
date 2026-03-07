## Setup Script

Prerecs: bash, git, ssh
untested: best to run line-by-line

``` bash
cd ~ \
mkdir Workspace \
git clone git@github.com/harleydutton/.dotfiles.git \
cd .dotfiles/.local/bin \
./dir-ln.sh ~/.dotfiles ~ ".*(/\.git/|README\.md|root).*" \
ssh-keygen.sh \
chsh -s $(which zsh)
```

### notes
- might have problems because using ssh. If so, remember to change it to ssh at the end (~/.dotfiles/git/config)
- find some way to integrate google keep and waybar (taskwarrior and syncall?)
- rss module for waybar?
- calendar module waybar?
- email (and text? discord?) notification module for waybar
