cd ~
git init
git remote add origin git@github.com:harleydutton/dotfiles.git
echo "*" >> .gitignore
git commit --allow-empty -m "from dotfile-repo-setup.sh"
git fetch
git branch -u origin/main
git pull origin main --rebase -X theirs --allow-unrelated-histories
rm -rf ./dotfiles README.md
