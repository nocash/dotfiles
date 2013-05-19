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

source ~/.zshrc.prompt

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep # lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Add our personal bin directory to PATH
PATH=$HOME/bin:$PATH

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

# Terminal type detection trickeries
# http://vim.wikia.com/wiki/256_colors_in_vim
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi

SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'."
            export TERM=xterm
            ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'."
            export TERM=rxvt
            ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'."
            export TERM=screen
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi # end of terminal detection

# Disable XON/XOFF flow control
stty -ixon

# OS-specific settings
case "$PLATFORM" in
  'osx')
    VISUAL=mvim
    alias ls='ls -G'
    alias gv='mvim --remote-silent'
    ;;
  *)
    VISUAL=gvim
    alias ack='ack-grep'
    alias ls='ls --color=auto'
    alias gv='gvim --remote-silent'
    alias open='xdg-open'
    ;;
esac

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

## Aliases: General
alias be='bundle exec'
alias gwd='git rev-parse --show-toplevel'
alias gcb='git symbolic-ref --quiet --short HEAD'
alias ll='ls -lh'
alias tree='tree -C'
alias sv='sudo vim'

## Aliases: Apache
alias a2e='sudo a2ensite'
alias a2d='sudo a2dissite'
alias a2r='sudo service apache2 reload'
alias a2rr='sudo service apache2 restart'

## Aliases: Vagrant
alias vh='vagrant halt'
alias vhf='vagrant halt --force'
alias vr='vagrant reload --no-provision'
alias vrp='vagrant reload --provision'
alias vs='vagrant suspend'
alias vu='vagrant up --no-provision'
alias vup='vagrant up --provision'

# Miscellaneous functions
function -(){ cd - }
function checkopt() { echo $options[$1] }

# Load Git completion
if [ -f "/usr/local/etc/bash_completion.d/git-completion.bash" ]; then
  source '/usr/local/etc/bash_completion.d/git-completion.bash'
elif [ -f "$HOME/.git-completion.bash" ]; then
  source "$HOME/.git-completion.bash"
fi

# Add Vagrant to PATH
[[ -s '/opt/vagrant/bin/vagrant' ]] && export PATH="$PATH:/opt/vagrant/bin"

# Check for htop and wrap top if it's available.
if ( which htop &>/dev/null ) { function top(){ htop "$@"} }

# Check for hub and wrap git if it's available.
if ( which hub &>/dev/null ) { function git(){ hub "$@"} }

# Modify our keyboard
[[ -f "$HOME/.xmodmaprc" ]] && xmodmap $HOME/.xmodmaprc

# This loads RVM into a shell session.
PATH=$PATH:$HOME/.rvm/bin
[[ -f "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# fpath=(~/.zsh/Completion $fpath)

# https://github.com/joelthelion/autojump
[[ -s /etc/profile.d/autojump.zsh ]] && source /etc/profile.d/autojump.zsh
[[ "$PLATFORM" == 'osx' && -f `brew --prefix`/etc/autojump.zsh ]] && source `brew --prefix`/etc/autojump.zsh

# https://github.com/rupa/z
[[ -s $HOME/lib/z/z.sh ]] && source $HOME/lib/z/z.sh

# Include machine-specifc configuration
[[ -f "$HOME/.zshrc.$HOST" ]] && . "$HOME/.zshrc.$HOST"
[[ -f "$HOME/.zshrc.local" ]] && . "$HOME/.zshrc.local"
