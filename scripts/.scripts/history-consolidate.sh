cd ~
cat .bash_history .zsh_history .histfile > temp
mv temp .histfile
rm .bash_history .zsh_history
