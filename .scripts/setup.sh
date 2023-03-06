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
git fetch
