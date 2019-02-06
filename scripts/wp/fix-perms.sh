#!/bin/bash
pushd $( git rev-parse --show-toplevel )

find . -mindepth 1 ! -user www-data -o ! -group `whoami` | grep -vF ./.git | xargs -r sudo chown -v www-data:`whoami`
find . -mindepth 1 -type d ! -perm 775 | grep -vF ./.git | xargs -r sudo chmod -v 775
find . -mindepth 1 -type f ! -perm 664 | grep -vF ./.git | xargs -r sudo chmod -v 664

if [[ "$1" == '--clean' ]]; then
  git clean -fd
fi

popd
