#JAVA
java8(){ export JAVA_HOME=`/usr/libexec/java_home -v 1.8` }
java11(){ export JAVA_HOME=`/usr/libexec/java_home -v 11.0` }
java15(){ export JAVA_HOME=`/usr/libexec/java_home -v 15.0` }
java17(){ export JAVA_HOME=`/usr/libexec/java_home -v 17.0` }
java19(){ export JAVA_HOME=`/usr/libexec/java_home -v 19.0` }
java11
export PATH="$PATH:$JAVA_HOME/bin"


#HISTORY
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

#GIT BRANCH
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'

#PROMPT
PROMPT='%n@%m %~ %# '

#TAB-COMPLETE
autoload -U compinit promptinit
promptinit
compinit -i
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
fpath=(/usr/local/share/zsh-completions $fpath)
