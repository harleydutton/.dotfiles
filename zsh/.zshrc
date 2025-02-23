#ZSH
##PROMPT
PROMPT='%S %~ > %s'

##HISTORY
HISTFILE=~/.histfile
setopt share_history
alias hist="history -i 0"
alias hg="hist|grep"

##ZSH DELETE FIX
bindkey "^[[3~" delete-char

##AUTOCOMPLETE
source ~/.zsh_plugins/zsh-z/zsh-z.plugin.zsh
source ~/.zsh_plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

##GIT STATUS RPROMPT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
RPROMPT='%S ${vcs_info_msg_0_} %s'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '%b%u%c'
alias gs="git status -s"

#LS
alias lsla="ls -la"

#SSH
eval `ssh-agent` > /dev/null
ssh-add -q ~/.ssh/id_ed25519 

#TAR
alias targz="tar -xf"

#KUBERNETES
alias kc="kubectl"
alias keti="kc exec -ti"

#MAVEN
alias mci="mvn clean install"

#TOOLBOX
alias te="toolbox enter"
tb-name () {
    cat /run/.containerenv | sed -n 2p | awk -F '"' 'NF>2{print $2}'
}
if [[ "$HOST" == "toolbx" ]]; then PROMPT="%S[$(tb-name)]%s$PROMPT"; fi

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
fi

