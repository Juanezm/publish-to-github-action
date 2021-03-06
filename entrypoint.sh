#!/bin/sh

# check values
if [ -z "${GITHUB_TOKEN}" ]; then
    echo "error: not found GITHUB_TOKEN"
    exit 1
fi

if [ -z "${BRANCH}" ]; then
    BRANCH=master
fi

# initialize git
remote_repo="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git config http.sslVerify false
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git remote add publisher "${remote_repo}"
git show-ref # useful for debugging
git branch --verbose

# install lfs hooks
git lfs install

# publish any new files
git checkout ${BRANCH}
git add -A
git commit -m "${COMMIT_MSG}" || exit 0
git pull --rebase publisher ${BRANCH}
git push publisher ${BRANCH}
