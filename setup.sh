#place dotfiles repo in home
cd ~
git init
git remote add origin git@github.com:harleydutton/dotfiles.git
echo "*" >> .gitignore
git commit --allow-empty -m "from setup.sh"
git branch --set-upstream-to=origin/<branch> master
git pull --rebase -X theirs --allow-unrelated-histories
# rm -rf ./dotfiles

#install commentary for vim
# mkdir -p ~/.vim/pack/tpope/start
# cd ~/.vim/pack/tpope/start
# git clone https://tpope.io/vim/commentary.git
# vim -u NONE -c "helptags commentary/doc" -c q


#determine package manager
# PM="something or other"

#cli=vim zsh git python3 ssh java
#some kind of clipboard manager
#apps=discord obsidian chrome bitwarden
#silverblue= fuzzel waybar sway

