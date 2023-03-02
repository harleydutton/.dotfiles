#place dotfiles repo in home
cd ~
git init
git remote add origin git@github.com:harleydutton/dotfiles.git
echo .* >> .gitignore
echo * >> .gitignore
git checkout -b temp
git add .
git commit -m "initial commit"
git checkout master
git pull origin master --allow-unrelated-histories
# rm -rf ./dotfiles

#install commentary for vim
mkdir -p ~/.vim/pack/tpope/start
cd ~/.vim/pack/tpope/start
git clone https://tpope.io/vim/commentary.git
vim -u NONE -c "helptags commentary/doc" -c q


#determine package manager
# PM="something or other"

#cli=vim zsh git python3 ssh java
#some kind of clipboard manager
#apps=discord obsidian chrome bitwarden
#silverblue= fuzzel waybar sway

