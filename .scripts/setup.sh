# cd ~; git clone git@github.com:harleydutton/dotfiles.git; ./dotfiles/.scripts/setup.sh

#place dotfiles repo in home
cd ~
git init
git remote add origin git@github.com:harleydutton/dotfiles.git
echo "*" >> .gitignore
git commit --allow-empty -m "from setup.sh"
git branch -u origin/main
git pull origin main --rebase -X theirs --allow-unrelated-histories
rm -rf ./dotfiles

#installs
.scripts/install-commentary.sh #todo: try out tcomment. commentary doesn't work well out of the box


#determine package manager
# PM="something or other"

#cli=vim zsh python3 ssh java keychain
#some kind of clipboard manager
#apps=discord obsidian chrome bitwarden
#silverblue= fuzzel waybar sway

