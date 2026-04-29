# default system toolbox -- included:
# btop for monitoring
# screenshot tools (grim, slurp, wl-copy)
# music management tools (yt-dlp, ffprobe, ffmpeg, libshaderc, spirv-tools python3-pip) (rclone)
sudo dnf install -y grim slurp wl-copy btop rclone ffmpeg ffprobe python3-pip spirv-tools libshaderc
python3 -m pip install -U --pre "yt-dlp[default]"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-  $(rpm -E %fedora).noarch.rpm 
