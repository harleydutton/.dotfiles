# default system toolbox -- included:

toolbox create sys
toolbox run -c sys bash -c "sudo dnf install -y btop" #monitoring
toolbox run -c sys bash -c "sudo dnf install -y grim slurp wl-copy" #screenshot
toolbox run -c sys bash -c "sudo dnf install -y rclone" #music sync

# music download (yt-dlp)
#sudo dnf install -y yt-dlp ffprobe ffmpeg python3-pip
#python3 -m pip install -U --pre "yt-dlp[default]"
#sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 

# dedupeing app (opustags, fpcalc)
#sudo dnf install -y opustags fpcalc
# pip reqs in pipx or similar: numpy, chromaprint


# unsure: spirv-tools libshaderc




# from the ytdlp toolbox
#   echo "This needs to be run from inside a toolbox"
#   sudo dnf install python3-pip
#   python3 -m pip install -U --pre "yt-dlp[default]"
#   sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
#   sudo dnf install ffmpeg ffprobe
#   echo "add /home/hdutton/.local/bin to PATH"
