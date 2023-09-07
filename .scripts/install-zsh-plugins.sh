echo "zsh plugin dir: "$ZSH_PLUGINS
rm -rf $ZSH_PLUGINS
mkdir -p $ZSH_PLUGINS
cd $ZSH_PLUGINS
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
git clone https://github.com/agkozak/zsh-z.git
