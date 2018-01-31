#!/usr/bin/env bash

# inspiration from https://gist.github.com/domenic/ec8b0fc8ab45f39403dd

# exit with non-zero status on any failed command
set -e

# Variables
# --------------------
#
# REPO - git repository URL
# ROOT_DIR - root directory
# SHA - git SHA hash for current commit
# SOURCE_BRANCH - current branch being built/tested/etc.
# SSH_REPO - ssh address/branch combo
#
REPO=`git config remote.origin.url`
ROOT_DIR=`$(pwd)`
SHA=`git rev-parse --verify HEAD`
SOURCE_BRANCH="master"
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
TARGET_BRANCH="deployment"

function compile-all {
    cd $ROOT_DIR
    make debug
    make release
}

function test-all {
    cd $ROOT_DIR
    make test
}

# pull requests and commits to other branches should only build, not try to
# deploy
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != $SOURCE_BRANCH ]
then
    echo "Skipping deployment; just building and testing."
    compile-all
    test-all
    exit 0
fi

# set git options
git config --global user.name "Travis CI"
git config --global user.email "ci@travis-ci.org"
get remote set-url origin "${SSH_REPO}"







