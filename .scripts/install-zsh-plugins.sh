ZSH_PLUGINS=~/.zsh_plugins
rm -rf $ZSH_PLUGINS
mkdir -p $ZSH_PLUGINS
cd $ZSH_PLUGINS
pwd
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
git clone https://github.com/agkozak/zsh-z.git
