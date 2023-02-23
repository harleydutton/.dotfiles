#!/bin/bash
#we may have to assume a few things: python, git, wget, curl, etc...
PLATFORM="$(python3 -m platform)"
echo $PLATFORM

echo "input package manager install command i.e. apt-get install"
read PMI

cli=vim zsh tmux git python3 ssh java
gui=discord obsidian chrome bitwarden

/* $PMI "$myPacks" */

SUB='Mac'
if [[ "$PLATFORM" =~ *"$SUB"* ]]; then
  echo "It's there."
fi


/* homebrew works on linux, windows, and mac */
/* /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" */



#just look for the install?
/* YUM_CMD=$(which yum) */
/* APT_GET_CMD=$(which apt-get) */
/* OTHER_CMD=$(which <other installer>) */
/* if [[ ! -z $YUM_CMD ]]; then */
/*     yum install $YUM_PACKAGE_NAME */
/* elif [[ ! -z $APT_GET_CMD ]]; then */
/*     apt-get $DEB_PACKAGE_NAME */
/* elif [[ ! -z $OTHER_CMD ]]; then */
/*     $OTHER_CMD <proper arguments> */
/* else */
/*     echo "error can't install package $PACKAGE" */
/*     exit 1; */
/* fi */















