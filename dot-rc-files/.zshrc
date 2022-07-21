
# Path to your oh-my-zsh installation.
export ZSH="/Users/corysmith/.oh-my-zsh"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

## kubectl krew
export PATH="${PATH}:${HOME}/.krew/bin"

export PATH=/opt/homebrew/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="afowler"

#export LS_COLORS="di=1;31"
#export LS_COLORS="di=34;40:ln=36;40:so=35;40:pi=33;40:ex=32;40:bd=1;33;40:cd=1;33;40:su=0;41:sg=0;43:tw=0;42:ow=34;40:"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#export LS_COLORS=ExFxBxDxCxegedabagacad
#export TERM='xterm-256color'

export LS_COLORS="di=34;40:ln=36;40:so=35;40:pi=33;40:ex=32;40:bd=1;33;40:cd=1;33;40:su=0;41:sg=0;43:tw=0;42:ow=34;40:"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

###################
# ALIAS
###################
alias repos='cd "$HOME/workspace/repos/"'
alias devips='aws ec2 describe-instances --query "Reservations[*].Instances[*].PrivateIpAddress" --output=text'
alias python='/usr/bin/python3'

alias k='/usr/local/bin/kubectl'
alias kctx='kubectx'
alias kg='kubectl get'
alias kgn='kubectl get ns'
alias kgp='kubectl get pod -n'
alias kgi='kubectl get ingress -n'
alias kge='kubectl get events --sort-by=lastTimestamp'
alias ktn='~/.env/top_nodes.sh'
alias kclean='kubectl get pods --all-namespaces | grep Evicted | awk '{print $1}' | xargs kubectl delete pod'
alias kt='kubetail'
alias kutil='kubectl get nodes --no-headers | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''
alias kmem='util | grep % | awk '\''{print $5}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*75), "%\n" } }'\'''

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
plugins=(kubetail)


source $ZSH/oh-my-zsh.sh
export LSCOLORS="exgxfxdacxDaDaxbadacex"

# Source custom zsh files
source ~/zshrc/custom/cdp.zsh
source ~/zshrc/custom/ke.zsh

#### SETTING DEFAULT ENVIRONMENTS TO STAGING #####
#source "$HOME/.env/defaults.sh"
#source "$HOME/.env/set_env.sh" sandbox

source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/Users/corysmith/.okta/bin:$PATH"
set -o vi

#OktaAWSCLI
function okta-aws {
    OKTA_PROFILE="$1" withokta "aws --profile $1" "${@:2}"
}
function okta-sls {
    OKTA_PROFILE="$1" withokta "sls --stage $1" "${@:2}"
}


HISTSIZE=1000000
bindkey '^R' history-incremental-pattern-search-backward

export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"
export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/corysmith/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)