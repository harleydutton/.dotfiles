# cd ~; git clone https://github.com/harleydutton/dotfiles.git; ./dotfiles/.scripts/setup.sh

#variables
EMAIL="harleydutton@gmail.com"

#git and ssh
git config --global init.defaultBranch main
git config --global user.email $EMAIL
ssh-keygen -t ed25519 -C $EMAIL
eval `ssh-agent`
ssh-add ~/.ssh/id_ed25519

#place dotfiles repo in home
cd ~
git init
git remote add origin git@github.com:harleydutton/dotfiles.git
echo "*" >> .gitignore
git commit --allow-empty -m "from setup.sh"
git branch -u origin/main
git pull origin main --rebase -X theirs --allow-unrelated-histories
rm -rf ./dotfiles
git fetch
