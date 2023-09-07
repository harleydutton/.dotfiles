#KEYCHAIN
PATH=$PATH:/var/home/harleydutton/.cargo/bin
eval `keychain -q -k others --eval ~/.ssh/id_ed25519`
