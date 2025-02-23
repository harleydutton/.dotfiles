echo "This needs to be run from inside a toolbox"
sudo dnf install python3-pip
python3 -m pip install -U --pre "yt-dlp[default]"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install ffmpeg ffprobe
echo "add /home/hdutton/.local/bin to PATH"
