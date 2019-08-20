###

function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "!${RETVAL}"
}

export PS1="\n\s\v:\w \`nonzero_return\`\n\$ "

###

# https://remysharp.com/2018/08/23/cli-improved
if command -v bat &>/dev/null; then alias cat='bat'; fi
if command -v prettyping &>/dev/null; then alias ping='prettyping -nolegend'; fi

###

alias ag='ag --pager=less\ --quit-if-one-screen\ --RAW-CONTROL-CHARS\ --chop-long-lines\ --no-init'
alias ls='ls -G'
alias g='git'
alias tree='tree -C'

alias pbc='pbcopy'
alias pbp='pbpaste'

#---

-      () { cd - ; }
inline () { xargs echo -n ; }
lc     () { tr '[:upper:]' '[:lower:]' < <(echo -n "$@") ; }
rr     () { stty sane ; }
tr-    () { tr '[:space:]' '-' < <(echo -n "$@") ; }
xa     () { xargs "$@" ; }

###

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

cnf_git_alias() {
  local command="$1"

  # Execute a Git alias prefixed with 'g'.
  if [ 'g' = "${command:0:1}" ]; then
    local alias="${command:1}"
    if git config --get "alias.${alias}" &>/dev/null; then
      exec git $alias "${@:2}"
    fi
  fi
}

# create a copy of the original command not found handler
# copy_function command_not_found_handle orig_command_not_found_handle

command_not_found_handle() {
  local command=$1
  shift
  local args=("$@")

  cnf_git_alias "$command" "${args[@]}"
  # orig_command_not_found_handle "$command" "${args[@]}"

  # If none of the above functions take control with "exec" then fail normally.
  return 127
}


###

export LESS="\
  --quit-if-one-screen \
  --RAW-CONTROL-CHARS \
  --chop-long-lines \
  --no-init \
  --jump-target=.5"

#---

PATH="${PATH}:${HOME}/bin"

#--- asdf

. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

#--- homebrew
# Authenticate Homebrew requests
[[ -s "$HOME/.homebrew_github_api_token" ]] \
  && export HOMEBREW_GITHUB_API_TOKEN="$(< $HOME/.homebrew_github_api_token)"

#--- direnv
eval "$(direnv hook bash)"

#--- gatsby
export GATSBY_TELEMETRY_DISABLED=1

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/beaubeveridge/src/hello-epics/node_modules/tabtab/.completions/serverless.bash ] && . /Users/beaubeveridge/src/hello-epics/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/beaubeveridge/src/hello-epics/node_modules/tabtab/.completions/sls.bash ] && . /Users/beaubeveridge/src/hello-epics/node_modules/tabtab/.completions/sls.bash
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f /Users/beaubeveridge/src/hello-epics/node_modules/tabtab/.completions/slss.bash ] && . /Users/beaubeveridge/src/hello-epics/node_modules/tabtab/.completions/slss.bash