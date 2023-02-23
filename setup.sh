cp .vimrc ~/.vimrc
cp .inputrc ~/.inputrc
cp .zshrc ~/.zshrc

#determine package manager
PM="something or other"


#cli=vim zsh tmux git python3 ssh java
#apps=discord obsidian chrome bitwarden

#install commentary for vim
mkdir -p ~/.vim/pack/tpope/start
cd ~/.vim/pack/tpope/start
git clone https://tpope.io/vim/commentary.git
vim -u NONE -c "helptags commentary/doc" -c q
