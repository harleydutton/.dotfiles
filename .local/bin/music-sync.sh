#!/bin/bash

# DOWNLOAD NEW MUSIC
#yt-dlp -x "https://www.youtube.com/watch?v=qlrpeYdm9Ec&list=PL6RC7EWwJgkLLmnYqiTEksxWjVuKKvrOI"                                                                     

# UPLOAD NEW MUSIC
mkdir -p ~/Downloads/new-music
if [ -n "$(ls ~/Downloads/new-music)" ]; then
    rclone copy ~/Downloads/new-music gdrive:Music
    if [ $? -eq 0 ]; then
        rm -f ~/Downloads/new-music/*
    else
        echo "Aborting: Failed to upload all files!"
        exit 1
    fi
fi

# TWO WAY SYNK DELETE > MODIFY
rclone sync gdrive:Music ~/Music --ignore-existing
rclone sync ~/Music gdrive:Music --ignore-existing


