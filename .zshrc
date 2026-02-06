#ZSH

##ZSH PLUGINS
source ~/.zsh_plugins/zsh-z/zsh-z.plugin.zsh
source ~/.zsh_plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ~/.zsh_plugins/fzf/shell/key-bindings.zsh #ctrl+r
export PATH="$HOME/.zsh_plugins/fzf/bin:$PATH"

#USER BIN
export PATH=/home/hdutton/.local/bin:$PATH

#SSH
eval `ssh-agent` > /dev/null
ssh-add -q ~/.ssh/id_ed25519 

##ZSH DELETE FIX (laptop specific?)
bindkey "^[[3~" delete-char

##ZSH-AUTOCOMPLETE
zstyle ':autocomplete:*' min-input 9999 # autocomplete causes lag/stutter so it's off
zstyle ':autocomplete:*' append-semicolon no #diable annoying
#zstyle ':autocomplete:*' add-space no #disable annoying
#bindkey -M menuselect '\r' .accept-line #enter always escapes menus
#Arrows escape menus
#bindkey -M menuselect '^[[C' .forward-char '^[OC' .forward-char
#bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char 

##HISTORY
export HISTFILE=~/.histfile
setopt share_history

##PROMPT
export PROMPT='%S %~ > %s'

##GIT STATUS RPROMPT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
export RPROMPT='%S ${vcs_info_msg_0_} %s'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '%b%u%c'
alias gs="git status -s"

#TOOLBOX PROMPT
alias te="toolbox enter"
tb-name () {
    cat /run/.containerenv | sed -n 2p | awk -F '"' 'NF>2{print $2}'
}
if [[ "$HOST" == "toolbx" ]]; then PROMPT="%S[$(tb-name)]%s$PROMPT"; fi

#TAR
alias targz="tar -xf"

#KUBERNETES
alias kc="kubectl"
alias keti="kc exec -ti"

#MAVEN
alias mci="mvn clean install"

#FEDORA ATOMIC
alias pm="rpm-ostree"


#TOOLBOX TEMP
if [[ $HOST == "toolbx" ]]; then
    if [[ $(tb-name) == "appium" ]]; then
        export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
        export ANDROID_HOME=/home/hdutton/Android/Sdk
        export PATH=/home/hdutton/bin/node_modules/bin:$PATH
        export PATH=/home/hdutton/bin/android-studio/bin:$PATH
        export PATH=/home/hdutton/Android/Sdk:$PATH
    fi
    if [[ $(tb-name) == "yt-dlp" ]]; then
        alias dl="yt-dlp -x"
    fi
fi

