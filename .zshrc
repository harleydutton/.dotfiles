#PROMPT
PROMPT='%~ > '

#HISTORY
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
HIST_STAMPS="yyyy--mm-dd"
setopt appendhistory
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
alias hist="history -i 0"
alias hg="hist|grep"

#TAB-COMPLETE
autoload -U compinit promptinit
promptinit
compinit -i
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
fpath=(/usr/local/share/zsh-completions $fpath)

#GIT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
RPROMPT='${vcs_info_msg_0_}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '%b%u%c'
alias gs="git status -s"
# I also want something that will automatically fetch pretty regularly.

#JAVA
# java11(){ export JAVA_HOME=`/usr/libexec/java_home -v 11.0` } 
# java17(){ export JAVA_HOME=~/.java/jdk-17.0.6+10 } 
# java11 
# export PATH="$PATH:$JAVA_HOME/bin"  #some of this belongs in .profile

#KUBERNETES
# alias kc="kubectl" 
# alias keti="kc exec -ti" 
# alias kcgc="kc config get-contexts" 
# alias kccc="kc config current-context"
# alias kcuc="kc config use-context" 
# globald(){ 
#     export KUBECONFIG="$HOME/.kube/eks-rome-globald_p2996224.config" 
#     kubectl config set-context --current --namespace=scl-dev 
# } 
# globald 

# TODO
# eval $(ssh-agent); ssh-add ~/.ssh/github
# probably keychain rather than this
# perhaps write a script to setup .ssh/github on a new machine
# fix commentary comments in .zshrc
