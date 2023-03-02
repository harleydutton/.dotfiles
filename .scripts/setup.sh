# cd ~; git clone git@github.com:harleydutton/dotfiles.git; ./dotfiles/.scripts/setup.sh

#place dotfiles repo in home
cd ~
git init
git remote add origin git@github.com:harleydutton/dotfiles.git
echo "*" >> .gitignore
git commit --allow-empty -m "from setup.sh"
git branch -u origin/master
git pull origin master --rebase -X theirs --allow-unrelated-histories
rm -rf ./dotfiles

#installs
./.scripts/install-commentary.sh


#determine package manager
# PM="something or other"

#cli=vim zsh python3 ssh java
#some kind of clipboard manager
#apps=discord obsidian chrome bitwarden
#silverblue= fuzzel waybar sway

