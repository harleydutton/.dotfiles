rm -rf ~/.zsh_plugins
mkdir ~/.zsh_plugins
cd ~/.zsh_plugins
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
git clone https://github.com/agkozak/zsh-z.git
git clone --depth 1 https://github.com/junegunn/fzf.git 
fzf/install --bin

