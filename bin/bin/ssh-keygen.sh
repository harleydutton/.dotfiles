ssh-keygen -t ed25519
eval `ssh-agent`
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
#the only way this gets better is if it automatically copies the info I need to paste into github to clipboard
