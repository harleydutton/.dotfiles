#PROMPT
PROMPT='%S %~ > %s'

#HISTORY
HISTSIZE=1000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"
setopt appendhistory
alias hist="history -i 0"
alias hg="hist|grep"

#PLUGINS
ZSH_PLUGINS=~/.zsh_plugins
source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGINS/zsh-z/zsh-z.plugin.zsh
source $ZSH_PLUGINS/zsh-autocomplete/zsh-autocomplete.plugin.zsh

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
# the below are dubiously useful. consider removing
alias kgn="kc get ns"
alias kgp="kc get pods"
alias kdp="kc describe pods"
alias klf="kc logs -f"
alias kcgc="kc config get-contexts"
alias kccc="kc config current-context"
alias kcuc="kc config use-context"

#SILVERBLUE+SWAYWM
alias pm="rpm-ostree"
addId(){keychain -q ~/.ssh/id_ed25519}
alias git="addId; git"
