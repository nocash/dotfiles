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

# Keep # lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
[[ $PLATFORM = 'linux' ]] && eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# temporary workaroud for https://github.com/mxcl/homebrew/issues/16992
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# Miscellaneous options
setopt autocd
setopt share_history
setopt autopushd
setopt no_nomatch

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
export LESS="-FRSX"

# compdef
compdef g=git

# OS-specific settings
case "$PLATFORM" in
  'osx')
    VISUAL=mvim
    alias ls='ls -G'
    alias vim='mvim -v'
    ;;
  *)
    VISUAL=gvim
    alias ack='ack-grep'
    alias ls='ls --color=auto'
    alias open='xdg-open'
    ;;
esac

## Aliases: General
alias be='bundle exec'
alias htop='sudo htop'
alias ll='ls -lh'
alias tree='tree -C'

## Aliases: Git
alias -g foh='-f origin HEAD'
alias -g gcb='`g cb`'
alias -g glb='@{-1}'
alias -g gwd='`g wd`'
alias -g ldm='`g branch-base`'
alias -g ocb='origin/`g cb`'
alias g='git'
alias gdm='git diff `git branch-base`'
alias gtd='git todos `git branch-base`'

## Aliases: Vagrant
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

function trpxy() {
  local x=$1 y=$2
  tmux resize-pane -x $x -y $y
}

## Aliases: Misc.
alias ag='ag --color --group'
alias la='localeapp'
alias mqc='git commit --no-edit; script/mergeq --continue'
alias mqi='script/mergeq integration'
alias mqm='script/mergeq master'
alias zc='zeus c'
alias zg='zeus g'
alias zr='zeus rspec'
alias zrk='zeus rake'
alias zs='script/zeus'

function punch() {
  mkdir -p $1:h
  touch $1
}

function ole() { "$( git rev-parse --show-toplevel )/bin/open_last_error" "$@" }
function op() { "$( git rev-parse --show-toplevel )/bin/open_pull_request" "$@" }

# Miscellaneous functions
function -(){ cd - }
function checkopt() { echo $options[$1] }

# Load Git completion
# if [ -f "/usr/local/etc/bash_completion.d/git-completion.bash" ]; then
#   source '/usr/local/etc/bash_completion.d/git-completion.bash'
# elif [ -f "$HOME/.git-completion.bash" ]; then
#   source "$HOME/.git-completion.bash"
# fi

# Add Vagrant to PATH
[[ -s '/opt/vagrant/bin/vagrant' ]] && export PATH="$PATH:/opt/vagrant/bin"

# Check for hub and wrap git if it's available.
if ( command -v hub >&- ) { function git(){ hub "$@"} }

# https://github.com/joelthelion/autojump
[[ -s /etc/profile.d/autojump.zsh ]] && source /etc/profile.d/autojump.zsh
[[ "$PLATFORM" == 'osx' && -f `brew --prefix`/etc/autojump.zsh ]] && source `brew --prefix`/etc/autojump.zsh

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

# command-not-found hook
command_not_found_handler() {
  local g_alias cmd="$1"

  # Execute a Git alias prefixed with 'g'.
  if [ 'g' = $cmd[1] ]; then
    g_alias=$cmd[2,-1]
    git config --get "alias.$g_alias" &>/dev/null
    if [ $? -eq 0 ]; then
      exec git $g_alias "${@[2,-1]}"
    fi
  fi

  return 127
}

# set our prompt options
[[ -f "$HOME/.zshrc.prompt" ]] && . "$HOME/.zshrc.prompt"

# Include machine-specifc configuration
[[ -f "$HOME/.zshrc.$HOST" ]] && . "$HOME/.zshrc.$HOST"
[[ -f "$HOME/.zshrc.local" ]] && . "$HOME/.zshrc.local"

# Run TMUX if tmux exists and we're not inside tmux.
if ( command -v tmux >&- && [ -z "$TMUX" ] ) { tmux new }
# if ( command -v wemux >&- && [ -z "$TMUX" ] ) { wemux new }
