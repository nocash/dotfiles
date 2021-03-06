# Set variable to allow platform-specific settings
PLATFORM=''
case `uname` in
  'Darwin')
    PLATFORM='osx'
    ;;
  'Linux')
    PLATFORM='linux'
    ;;
  *)
    PLATFORM='unknown'
    ;;
esac

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Use modern completion system
autoload -Uz compinit
compinit

# Miscellaneous options
setopt autocd
setopt sharehistory
setopt histignorealldups
setopt autopushd
setopt no_nomatch

# Keep # lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
# # eval "$(dircolors -b)"
# [[ $PLATFORM = 'linux' ]] && eval "$(dircolors -b)"
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
#
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# temporary workaround for https://github.com/mxcl/homebrew/issues/16992
# zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# Disable XON/XOFF flow control
stty -ixon

# Initialize ssh-agent
# http://mah.everybody.org/docs/ssh#run-ssh-agent
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
  eval `$SSHAGENT $SSHAGENTARGS`
  trap "kill $SSH_AGENT_PID" 0
fi

# Set preferred editor
EDITOR=vim

# Set less options
export LESS="\
  --quit-if-one-screen \
  --RAW-CONTROL-CHARS \
  --chop-long-lines \
  --no-init \
  --jump-target=.5"

# OS-specific settings
case "$PLATFORM" in
  'osx')
    VISUAL="mvim"
    alias ls='ls -G'
    alias vim='mvim -v'

    # http://docs.basho.com/riak/latest/ops/tuning/open-files-limit/#Mac-OS-X
    # ulimit -n 65536
    # ulimit -u 2048
    ;;
  *)
    VISUAL=gvim
    alias ack='ack-grep'
    alias ls='ls --color=auto'
    alias open='xdg-open'
    ;;
esac

## Aliases: General
alias grep='egrep'
alias htop='sudo htop'
alias ll='ls -lh'
alias tree='tree -C'

## Aliases: Git
compdef g=git
alias -g ocb='origin/`g cb`'
alias g='git'

## Aliases: Vagrant
alias vd='vagrant destroy'
alias vdf='vagrant destroy --force'
alias vh='vagrant halt'
alias vhf='vagrant halt --force'
alias vp='vagrant provision'
alias vr='vagrant reload --no-provision'
alias vrp='vagrant reload --provision'
alias vs='vagrant suspend'
alias vsh='vagrant ssh'
alias vst='vagrant status'
alias vu='vagrant up --no-provision'
alias vup='vagrant up --provision'

## Aliases: TMUX
alias trp='tmux resize-pane'
alias trpx='tmux resize-pane -x'
alias trpxx='tmux resize-pane -x 80'
alias trpxxx='tmux resize-pane -x 999'
alias trpy='tmux resize-pane -y'
alias trpyy='tmux resize-pane -y 24'
alias trpyyy='tmux resize-pane -y 999'
alias tx='tmux resize-pane -x 80'

## Aliases: Docker
alias dc='docker-compose'
alias dh='docker help'
alias dm='docker-machine'
alias dps='docker ps'
alias dpsa='docker ps --all'
alias dpsaq='docker ps --all --quiet'

function trpxy() {
  local x=$1 y=$2
  tmux resize-pane -x $x -y $y
}

## Aliases: Misc.
alias ag='ag --pager=less\ --quit-if-one-screen\ --RAW-CONTROL-CHARS\ --chop-long-lines\ --no-init'
alias chx='chmod +x'
alias chxx='chmod +x !$'
alias grake='rake -g'
alias start='noglob start'

alias pbc='pbcopy'
alias pbp='pbpaste'

# https://remysharp.com/2018/08/23/cli-improved
if command -v bat &>/dev/null; then alias cat='bat'; fi
if command -v prettyping &>/dev/null; then alias ping='prettyping -nolegend'; fi

function ffind() {
  find . -name "$@"
}
alias ffind='noglob ffind'

function px {
  ps aux | grep "$@"
}

function punch() {
  mkdir -p $1:h && touch $1
}

function op() {
  local script_path="$( git rev-parse --show-toplevel )/bin/open_pull_request"
  if [ ! -f "$script_path" ]; then
    script_path="$HOME/bin/open-pull-request"
  fi
  "$script_path" "$@"
}

# Miscellaneous functions
function -(){ cd - }
function checkopt() { echo $options[$1] }
function hgrep { fc -l -m "*${@}*" -10000 } # man zshbuiltins
function inline { xargs echo -n }
function lc { tr '[:upper:]' '[:lower:]' < <(echo -n "$@") }
function rr { stty sane }
function tr- { tr '[:space:]' '-' < <(echo -n "$@") }
function xa { xargs "$@" }

# Load Git completion
# if [ -f "/usr/local/etc/bash_completion.d/git-completion.bash" ]; then
#   source '/usr/local/etc/bash_completion.d/git-completion.bash'
# elif [ -f "$HOME/.git-completion.bash" ]; then
#   source "$HOME/.git-completion.bash"
# fi

# Authenticate Homebrew requests
[[ -s "$HOME/.homebrew_github_api_token" ]] \
  && export HOMEBREW_GITHUB_API_TOKEN="$(< $HOME/.homebrew_github_api_token)"

# https://github.com/tarjoilija/zgen
source "${HOME}/.zgen/zgen.zsh"
# check if there's no init script
if ! zgen saved; then
  zgen save
fi

# Add sbin to PATH
PATH="$PATH:/usr/local/sbin"
# Add Vagrant to PATH
[[ -s '/opt/vagrant/bin/vagrant' ]] && export PATH="$PATH:/opt/vagrant/bin"

function kgrep() {
  local karma_path="node_modules/karma/bin/karma"
  local karma_conf="spec/unit/karma.conf.coffee"
  local pattern="$@"
  $karma_path run $karma_conf -- --grep="${pattern}"
}

# Check for hub and wrap git if it's available.
if ( command -v hub >&- ) { function git(){ hub "$@"} }

# https://github.com/joelthelion/autojump
[[ "$PLATFORM" == 'osx' && -s $(brew --prefix)/etc/profile.d/autojump.sh ]] \
  && . $(brew --prefix)/etc/profile.d/autojump.sh

export GOPATH="$HOME/projects/go"

###############################################################################
##  Command Not Found Handler #################################################
###############################################################################

# When I type a command that does not exist and that command starts with the
# letter "g" then compare the *rest* of that command to my git aliases and, if
# one matches, execute the git alias and pass the remaining arguments to it.
#
# Given a .giconfig that looks like...
#
# [alias]
#   co = checkout
#
# ...then typing "gco develop" executes "git checkout develop".

## OLD:

# cnf_git_alias() {
#   local cmd
#   cmd="$1"

#   # Execute a Git alias prefixed with 'g'.
#   local g_alias
#   if [ 'g' = $cmd[1] ]; then
#     g_alias=$cmd[2,-1]
#     if git config --get "alias.${g_alias}" &>/dev/null; then
#       exec git $g_alias "${@[2,-1]}"
#     fi
#   fi
# }

## Untested in zsh:

cnf_git_alias() {
  local cmd
  cmd="$1"

  # Execute a Git alias prefixed with 'g'.
  local g_alias
  if [ 'g' = "${cmd:0:1}" ]; then
    g_alias="${cmd:1}"
    if git config --get "alias.${g_alias}" &>/dev/null; then
      exec git $g_alias "${@:2}"
    fi
  fi
}

command_not_found_handler() {
  cnf_git_alias $@

  # If none of the above functions take control with "exec" then fail normally.
  return 127
}

###############################################################################
##  Prompt  ###################################################################
###############################################################################

autoload -Uz promptinit && promptinit
autoload -U colors && colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# Set the prompt.
PROMPT='
%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}\
$(prompt_git_info)
%# '

###############################################################################
##  Docker  ###################################################################
###############################################################################

autoload -U add-zsh-hook
load-docker-machine-env() {
  if [[ -f .docker-machine && -r .docker-machine ]]; then
    docker_machine="$(<.docker-machine)"
    echo "Configuring environment for Docker machine \"${docker_machine}\"."
    eval $(docker-machine env "${docker_machine}")
    export DOCKER_MACHINE_DIR=$(pwd)
  elif [[ $(pwd) == ${DOCKER_MACHINE_DIR}* ]]; then
      # Do nothing if we move to a subdirectory or if NVM_RC_DIR hasn't been set.
  elif [[ -n $DOCKER_MACHINE_NAME ]]; then
    echo "Unsetting Docker machine environment variables."
    eval $(docker-machine env -u)
  fi
}
add-zsh-hook chpwd load-docker-machine-env
load-docker-machine-env

###############################################################################

# android development
export ANDROID_HOME="${HOME}/Library/Android/sdk/"

# direnv
eval "$(direnv hook zsh)"

# asdf
. "${HOME}/.asdf/asdf.sh"
. "${HOME}/.asdf/completions/asdf.bash"

###############################################################################
##  Additional Configuration  #################################################
###############################################################################

[[ -f "$HOME/.zshrc.$HOST" ]] && . "$HOME/.zshrc.$HOST"
[[ -f "$HOME/.zshrc.local" ]] && . "$HOME/.zshrc.local"

###############################################################################
###############################################################################
###############################################################################

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
# [[ -f /Users/beau/projects/hello-epics/functions/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/beau/projects/hello-epics/functions/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
# [[ -f /Users/beau/projects/hello-epics/functions/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/beau/projects/hello-epics/functions/node_modules/tabtab/.completions/sls.zsh

# Run TMUX if 1) shell is interactive 2) tmux is not already running 3) tmux command exists.
tmux_cmd="tmux"
# tmux_cmd="wemux"
if ( [[ "$-" = *"i"* ]] && [ -z "$TMUX" ] && command -v $tmux_cmd >&- ) { $tmux_cmd new }
