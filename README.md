## Setup Script

Prerecs: git, ssh
untested: best to run line-by-line

```bash
sudo rpm-ostree install vim zsh \
mkdir ~/Workspace \
cd ~; git clone https://github.com/harleydutton/.dotfiles.git \
cd ~/.dotfiles; git remote set-url origin git@github.com:harleydutton/.dotfiles.git \
cd ~/.dotfiles/.local/bin; ./dir-ln.sh ~/.dotfiles ~ ".*(/\.git/|README\.md|root).*"; ./ssh-keygen.sh; \
# reboot
sudo chsh $USER -s $(which zsh)
history-consolidate.sh
sys-toolbox-create.sh
```

### notes
- rss module for waybar?
- email, tasks, and calendar for PC?
