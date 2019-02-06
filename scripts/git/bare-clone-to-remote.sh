#!/bin/bash

REPO_PATH=$1
BARE_REPO_PATH="`basename $REPO_PATH`.git"

REMOTE_PATH="`echo $2 | sed 's-/$--'`/"
REMOTE_URL=${REMOTE_PATH}${BARE_REPO_PATH}

echo -n "Save remote as [origin]: "
read REMOTE_NAME
echo ""

[[ $REMOTE_NAME = '' ]] && REMOTE_NAME="origin"

git clone --bare $REPO_PATH
scp -r $BARE_REPO_PATH $REMOTE_PATH

rm -rf $BARE_REPO_PATH

cd $REPO_PATH
git remote add $REMOTE_NAME $REMOTE_URL
cd ..
