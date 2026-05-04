# default system toolbox -- included:

# monitor.desktop (btop)
sudo dnf install -y btop
# screenshot.sh (grim, slurp, wl-copy)
sudo dnf install -y grim slurp wl-copy
# music-sync.sh (rclone)
sudo dnf install -y rclone 

# music download (yt-dlp)
#sudo dnf install -y yt-dlp ffprobe ffmpeg python3-pip
#python3 -m pip install -U --pre "yt-dlp[default]"
#sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 

# dedupeing app (opustags, fpcalc)
#sudo dnf install -y opustags fpcalc
# pip reqs in pipx or similar: numpy, chromaprint


# unsure: spirv-tools libshaderc
