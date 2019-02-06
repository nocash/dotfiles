local remote=$1
local branch=$2
local directory=$3

git fetch $remote
git merge -s ours --no-commit $remote/$branch
git read-tree --prefix=$directory -u $remote/$branch
git commit -m "Merge '$remote/$branch' as subdir '$directory'"

git pull -s subtree $remote $branch
