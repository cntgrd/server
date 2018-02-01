#!/usr/bin/env bash

eval "$(ssh-agent -s)"
chmod 600 config/deploy_rsa
ssh-add config/deploy_rsa

debug() {
    git config --global push.default matching
    git remote add deploy ssh://git@$DEV_REMOTE_HOST:$DEV_REMOTE_PORT$DEV_REMOTE_DIR
    git push deploy dev
}

release() {
    git config --global push.default matching
    git remote add deploy ssh://git@$PROD_REMOTE_HOST:$PROD_REMOTE_PORT$PROD_REMOTE_DIR
    git push deploy dev
}

case $1 in
    -d | --debug )
    debug
    exit
    ;;
    -r | --release )
    release
    exit
    ;;
esac
