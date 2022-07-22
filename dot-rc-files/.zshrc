# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH="$PATH:$HOME/bin:$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin"

# Path to your oh-my-zsh installation.
export ZSH="/Users/ian/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="eastwood"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Configure kube-ps1 to manage our prompt
KUBE_PS1_SEPARATOR=''
KUBE_PS1_DIVIDER=':'
KUBE_PS1_SYMBOL_USE_IMG=true
source /opt/homebrew/opt/kube-ps1/share/kube-ps1.sh
PS1='$(kube_ps1)'$PS1

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Source custom built scripts for large profile functions
source ~/zshrc/custom/cdp.zsh
source ~/zshrc/custom/ke.zsh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

###########
# Generic #
###########

# alias cdp="cd ~/projects/"

#################
# Git Shortcuts #
#################

alias gfp="git fetch --all --prune"
alias gcb="git checkout -b"
alias gpo="git pull origin" 
alias gcm="git commit -m"
alias gpu="git push --set-upstream origin HEAD"

#####################
# Kubectl Shortcuts #
#####################

alias k="kubectl"
alias kctx='kubectx'
alias kg='kubectl get'
alias kgn='kubectl get ns'
alias kgp='kubectl get pod -n'
alias kgi='kubectl get ingress -n'
alias kge='kubectl get events --sort-by=lastTimestamp'
alias ktn='~/.env/top_nodes.sh'
alias kclean='kubectl get pods --all-namespaces | grep "Evicted" | awk "{print $1}" | xargs kubectl delete pod'
alias kt='kubetail'
alias kutil='kubectl get nodes --no-headers | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''
alias kmem='util | grep % | awk '\''{print $5}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*75), "%\n" } }'\'''


#######################
# Terraform Shortcuts #
#######################

alias tf="terraform"
alias tff="terraform fmt -recursive"
alias tfp="terraform plan"
alias tfd="terraform destroy"
alias tfa="terraform apply"
alias tfv="terraform validate"
alias tfi="terraform init"