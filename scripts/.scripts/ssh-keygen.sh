ssh-keygen -t ed25519
eval `ssh-agent`
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
