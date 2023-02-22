#define what this runs as i.e. !/bin/bash 
echo "input package manager install command i.e. apt-get install"
read PMI
myPacks="jq"
$PMI "$myPacks"

PLATFORM="$(python3 -m platform)"
echo $PLATFORM

SUB='Mac'
if [[ "$PLATFORM" =~ *"$SUB"* ]]; then
  echo "It's there."
fi


homebrew works on all of theses...




















