# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="nocash"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

unsetopt correct
unsetopt correct_all

setopt glob_complete

export PATH="$HOME/bin:$PATH"

export WORDCHARS='-._'

# Check PATH for hub ('=hub') and wrap git if it's available.
if ( which hub &>/dev/null ) { function git(){hub "$@"} }

# This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
# [[ -s "$HOME/.rvm/scripts/completion" ]] && . "$HOME/.rvm/scripts/completion"

# Include machine-specifc shell configuration
[[ -s "$HOME/.zshrc.$HOST" ]] && . "$HOME/.zshrc.$HOST"
