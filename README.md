## Setup Script

Prerecs: bash, git, ssh
untested: best to run line-by-line

``` bash
cd ~ \
git clone https://github.com/harleydutton/.dotfiles.git \
./.dotfiles/bin/dir-ln.sh ~/.dotfiles ~ ".*(/\.git/|README\.md|root).*" \
ssh-keygen.sh \
```

### notes
- make atomic shell start in toolbox unless otherwise indicated
- get zsh to stop being annoying when using arrow keysts
- find some way to integrate google keep and waybar (taskwarrior and syncall?)
- rss module for waybar?
- calendar module waybar?
- email (and text? discord?) notification module for waybar
