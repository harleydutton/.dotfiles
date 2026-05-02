#!/bin/bash
# requires quoted input
NEWDIR="$HOME/Downloads/new-music/"
LIST="$(echo "$1" | grep -oP 'list=[\w-]+(?=&|$)')"
BASE='https://www.youtube.com/watch?'
mkdir -p $NEWDIR
(
cd $NEWDIR
yt-dlp -x --audio-format opus "$BASE$LIST" 
)
rclone copy $NEWDIR gdrive:Music                                                                      
