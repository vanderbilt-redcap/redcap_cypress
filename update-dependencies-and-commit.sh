#!/usr/bin/env bash

set -e

if [ -n "$(git status --porcelain)" ]; then 
  echo The redcap_cypress directory is not clean
  exit
fi

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

npm install github:vanderbilt-redcap/redcap_rsvc#$rsvcCommit
npm install github:vanderbilt-redcap/rctf#$rctfCommit
npm link $rctfPath

git add package.json package-lock.json
git commit -m "rsvc to $rsvcCommit and rctf to $rctfCommit"
git push
