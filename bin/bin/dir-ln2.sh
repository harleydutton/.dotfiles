#!/usr/bin/env bash

log=~/.log
rm $log
echo "src: $1" >> $log
echo "dest: $2" >> $log
for top in "$1"/*; do
  echo "top: $top" >> $log
  if [[ "$top" == "." ]] || [[ "$top" == ".." ]] || [[ "$top" == ".git" ]] || [[ "$top" == "README.md" ]] then
    continue
  fi
  find "$top" -type f | while read -r file; do
    dir=$(dirname "$file")
    echo "dir: $dir" >> $log
    mkdir -p "$2${dir#$top}"
    echo "dir-top: ${dir#$top}" >> $log
    echo "mkdir: $2${dir#$top}" >> $log
    ln -sf "$file" "$2${file#$top}"
    echo "file: $file" >> $log
    echo "link: $2${file#$top}" >> $log
    echo "############################################" >> $log
  done
  echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $log
done




#   ${foo#pattern}: Removes the shortest match of pattern from the front (left) [14].
#   ${foo##pattern}: Removes the longest match of pattern from the front (left).
#   ${foo%pattern}: Removes the shortest match of pattern from the back (right) [14].
#   ${foo%%pattern}: Removes the longest match of pattern from the back (right). 





