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
java8(){ export JAVA_HOME=`/usr/libexec/java_home -v 1.8` }
java11(){ export JAVA_HOME=`/usr/libexec/java_home -v 11.0` }
java15(){ export JAVA_HOME=`/usr/libexec/java_home -v 15.0` }
java17(){ export JAVA_HOME=`/usr/libexec/java_home -v 17.0` }
java19(){ export JAVA_HOME=`/usr/libexec/java_home -v 19.0` }
java11
export PATH="$PATH:$JAVA_HOME/bin" #some of this belongs in .profile

#KUBERNETES (look into the oh-my-zsh plugin thing and probably delete most of these)
alias kc="kubectl"
alias kgn="kc get ns"
alias kgp="kc get pods"
alias kdp="kc describe pods"
alias keti="kc exec -ti"
alias klf="kc logs -f"
alias kcgc="kc config get-contexts"
alias kccc="kc config current-context"
alias kcuc="kc config use-context"
globalb(){
    export KUBECONFIG="$HOME/.kube/eks-rome-globalb_p2996224.config"
    kubectl config set-context --current --namespace=datadog
}
globald(){
    export KUBECONFIG="$HOME/.kube/eks-rome-globald_p2996224.config"
    kubectl config set-context --current --namespace=scl-dev
}
globale(){
    export KUBECONFIG="$HOME/.kube/eks-rome-globale_p2996224.config"
    kubectl config set-context --current --namespace=datadog
}
poc124(){
    export KUBECONFIG="$HOME/.kube/eks-rome-poc124_p2996224.config"
    kubectl config set-context --current --namespace=datadog
}
globald

#CHARTER
rvpn(){
    launchctl unload /Library/LaunchAgents/com.paloaltonetworks.gp.pangp*
    launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangp*
}

#PATH (move all PATH exports to .profile)
export PATH=/Users/P2996224/Tools/apache-maven-3.9.0/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# eval $(ssh-agent); ssh-add ~/.ssh/github
# probably keychain rather than this
# perhaps write a script to setup .ssh/github on a new machine
# fix commentary comments in .zshrc
