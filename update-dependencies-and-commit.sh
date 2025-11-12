#!/usr/bin/env bash

diffOutput=`git diff --cached --exit-code`
if [ $? -ne 0 ]; then
  echo The redcap_cypress must not have any staged changes for this script to function properly.
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

rsvcCommit=`git -C redcap_rsvc rev-parse HEAD`
rctfCommit=`git -C $rctfPath rev-parse HEAD`

npm install github:vanderbilt-redcap/redcap_rsvc#$rsvcCommit github:vanderbilt-redcap/rctf#$rctfCommit
npm link $rctfPath

git add package.json package-lock.json
git commit -m "rsvc to $rsvcCommit and rctf to $rctfCommit"
git push

(sleep 12m; msg mceverm 'Cypress cloud build should be complete by now') &
