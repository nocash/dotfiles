#!/bin/bash
#
# Clones the target Git repository, copies it to your Media Temple (gs) server
# and automates initial configuration.
#
# Reference:
# http://kb.mediatemple.net/questions/1594/Using+Git

# These are set by the first argument (repo path) passed in
TARGET=$1
REPO=`basename $1`.git

# MT server/authentication info. Aliases from SSH config will work.
# SERVER=serveradmin%mt-example.com@mt-example.com
# SERVER=mt-example.com
SERVER=cxzcxz.com

# Domain that hosts your git repos.
# DOMAIN=git.mt-example.com
DOMAIN=git.cxzcxz.com
REMOTE_PATH=domains/$DOMAIN/html/$REPO

# Create a bare clone of the target repo
git clone --bare $TARGET $REPO
touch $REPO/git-daemon-export-ok

# Copy bare repo to MT server
scp -r $REPO $SERVER:$REMOTE_PATH

# Configure repo on MT server
ssh $SERVER "cd $REMOTE_PATH
git --bare update-server-info
cd hooks
mv post-update.sample post-update
chmod a+x post-update"
