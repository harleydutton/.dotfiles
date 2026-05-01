# default system toolbox -- included:
# monitor.desktop (btop)
# screenshot.sh (grim, slurp, wl-copy)
# music download (yt-dlp)
# dupes.py (opustags)
# music-sync.sh (rclone)
# tagger.sh (fpcalc)
# unsure: ffprobe, ffmpeg, libshaderc, spirv-tools, python3-pip)
# pip reqs in pipx or similar: numpy, chromaprint
sudo dnf install -y grim slurp wl-copy btop rclone ffmpeg ffprobe python3-pip spirv-tools libshaderc opustags
python3 -m pip install -U --pre "yt-dlp[default]"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
