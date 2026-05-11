#!/usr/bin/env bash

if [[ -n "$(git status -s)" ]]; then
  echo The redcap_cypress repo must not have any uncommitted changes for this script to function properly.
  exit
fi

set -e

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

rsvcCommit=`git -C redcap_rsvc rev-parse --short HEAD`
rctfCommit=`git -C $rctfPath rev-parse --short HEAD`

npm install github:vanderbilt-redcap/redcap_rsvc#$rsvcCommit github:vanderbilt-redcap/rctf#$rctfCommit
npm link $rctfPath

git add package.json package-lock.json
git commit -m "rsvc to $rsvcCommit and rctf to $rctfCommit"
git push

# (sleep 12m; msg mceverm 'Cypress cloud build should be complete by now') &
