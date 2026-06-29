#!/usr/bin/env bash

if [[ -n "$(git status -s)" ]]; then
  echo The redcap_cypress repo must not have any uncommitted changes for this script to function properly.
  exit
fi

set -e
set -x

rsvcBranch=`git -C redcap_rsvc rev-parse --abbrev-ref HEAD`
if [ $rsvcBranch != 'marks-changes' ]; then
    echo Unexpected branch for rsvc 
    exit
fi

rctfPath='../../rctf'
rctfBranch=`git -C $rctfPath rev-parse --abbrev-ref HEAD`
if [ $rctfBranch != 'marks-changes' ]; then
    echo Unexpected branch for rctf 
    exit
fi

git -C redcap_rsvc fetch
commitsBehindStaging=`git -C redcap_rsvc log --oneline ..origin/staging | wc -l`
if [ $commitsBehindStaging != 0 ]; then
    # Make sure marks-changes includes any other PRs merged straight to staging
    git -C redcap_rsvc  merge origin/staging
    git -C redcap_rsvc push
fi

git -C $rctfPath fetch
commitsBehindMain=`git -C $rctfPath log --oneline ..origin/main | wc -l`
if [ $commitsBehindMain != 0 ]; then
    # Make sure marks-changes includes any other PRs merged straight to main
    git -C $rctfPath merge origin/main
    git -C $rctfPath push
fi

rsvcCommit=`git -C redcap_rsvc rev-parse --short HEAD`
rctfCommit=`git -C $rctfPath rev-parse --short HEAD`

git fetch
git merge origin/master

npm install github:vanderbilt-redcap/redcap_rsvc#$rsvcCommit github:vanderbilt-redcap/rctf#$rctfCommit
npm link $rctfPath

git add package.json package-lock.json
git commit -m "rsvc to $rsvcCommit and rctf to $rctfCommit"
git push

# (sleep 12m; msg mceverm 'Cypress cloud build should be complete by now') &
