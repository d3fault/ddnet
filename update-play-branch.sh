#!/bin/bash
set -xe

mybranches=(freeze-hammer-bot onjoin-messages nonverbose-binds)

git reset --hard
git checkout master
git pull
git checkout play
git rebase master play

#rebase all branches on top of master
for i in ${mybranches[@]}
do
	git checkout "$i"
	git rebase master "$i"	
done
git checkout play

#apply all commits from all branches to working directory
for i in ${mybranches[@]}
do
	git show $(git merge-base master "$i").."$i" | git apply --whitespace=nowarn -
done
echo ""
echo "update-play-branch.sh finished successfully"
