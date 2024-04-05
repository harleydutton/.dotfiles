flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.          flatpakrepo                           
flatpak install flathub md.obsidian.Obsidian
echo "[Desktop Entry]\
Name=Obsidian\
Exec=flatpak run md.obsidian.Obsidian\
Type=application\
Terminal=false\
Catefories=Office;" > ~/.local/share/applications/obsidian.desktop
