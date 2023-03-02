#OH-MY-ZSH (how do I install this? do I need to at this point?)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

#PLUGINS
plugins=(git)

#JAVA
java17(){ export JAVA_HOME=~/.java/jdk-17.0.6+10 }
java17
export PATH="$PATH:$JAVA_HOME/bin"

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
alias hg=hist|grep

#GIT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
RPROMPT='${vcs_info_msg_0_}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '%b%u%c'
git config --global alias.logline "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)      %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.dl "branch -D"
git config --global alias.dr "push -d origin"
git config --global alias.empty-commit "commit --allow-empty -m 'empty commit'"
alias gs="git status"

#PROMPT
PROMPT='%~ > '

#TAB-COMPLETE
autoload -U compinit promptinit
promptinit
compinit -i
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
fpath=(/usr/local/share/zsh-completions $fpath)

#SILVERBLUE
alias pm="rpm-ostree"
