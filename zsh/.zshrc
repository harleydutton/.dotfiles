#PROMPT
PROMPT='%S %~ > %s'

#HISTORY
HISTFILE=~/.histfile
setopt share_history
alias hist="history -i 0"
alias hg="hist|grep"

#DELETE
bindkey "^[[3~" delete-char

#COMPLETE
source ~/.zsh_plugins/zsh-z/zsh-z.plugin.zsh
source ~/.zsh_plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

#SSH
eval `ssh-agent` > /dev/null
ssh-add -q ~/.ssh/id_ed25519 

#GIT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
RPROMPT='%S ${vcs_info_msg_0_} %s'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '%b%u%c'
alias gs="git status -s"

#KUBERNETES
alias kc="kubectl"
alias keti="kc exec -ti"

#JAVA
JAVA_HOME=/usr/bin/java

#MAVEN
alias mci="mvn clean install"

#TOOLBOX
if [[ "$HOST" == "toolbox" ]]; then export ACCENT=◇ ; PROMPT="$ACCENT $PROMPT"; fi
alias te="toolbox enter"
alias tl="toolbox list"
alias tc="toolbox create"

#ATOMIC
alias pm="rpm-ostree"
