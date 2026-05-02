

MUSICDIR=$HOME/Workspace/temp
PATH="$HOME/.dotfiles/.local/bin/:$PATH"


#tag all
TEMPFILE=$HOME/.dotfiles/.local/bin/cache.txt # $HOME/.cache/music_dedupe_cache.txt
if [[ ! -f "$TEMPFILE" ]]; then
    for f in "$MUSICDIR"/*; do
        music-tagger.sh "$f"
    done
    find "$MUSICDIR" -maxdepth 1 -type f > "$TEMPFILE"
fi

while [[ -s "$TEMPFILE" ]]; do
    SONG1=$(head -1 "$TEMPFILE")
    sed -i '1d' "$TEMPFILE"
    while IFS= read -r SONG2; do
        echo "$SONG1" "$SONG2"
        music-dupes.py "$SONG1" "$SONG2" # do something with the comparison here
    done < "$TEMPFILE"
    echo "Done processing $SONG1"
done

rm "$TEMPFILE"

# Using python for the loops and cacheing the fingerprint list[int]s would improve performance by reducing disk reads

#   for f in "$MUSICDIR"/*; do
#     [[ -f "$f" ]] || continue
#     found=0
#     for g in "$MUSICDIR"/*; do
#       [[ -f "$g" ]] || continue
#       [[ $found -eq 1 ]] && echo "$f and $g"
#       [[ "$f" == "$g" ]] && found=1
#       echo "$f" "$g"
#     done
#   done




