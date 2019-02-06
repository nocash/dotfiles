#!/bin/bash

git filter-branch $1 --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "Beau Beveridge" ];
        then
                GIT_COMMITTER_NAME="Beau Dacious";
                GIT_AUTHOR_NAME="Beau Dacious";
                GIT_COMMITTER_EMAIL="dacious.beau@gmail.com";
                GIT_AUTHOR_EMAIL="dacious.beau@gmail.com";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD
