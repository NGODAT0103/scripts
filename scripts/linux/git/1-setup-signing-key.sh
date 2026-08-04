#!/bin/bash
set -e
#set -x
git config --global --unset gpg.format
gpg --list-secret-keys --keyid-format=long
read -p "Enter your secret_key_id" secret_key
git config --global user.signingkey $secret_key
git config --global commit.gpgsign true
