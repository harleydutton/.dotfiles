cd ~
cat .bash_history .zsh_history .histfile > histtempfile
mv histtempfile .histfile
rm .bash_history .zsh_history
