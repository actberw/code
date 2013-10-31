#!/usr/bin/env bash

# config user name and email
echo -n "User name is:"
read USERNAME
git config --local user.name $USERNAME
echo -n "User email is:"
read EMAIL
git config --local user.email $EMAIL


#config alias

git config --local color.ui true
git config --local alias.ci commit
git config --local alias.st status
git config --local alias.co checkout
git config --local core.editor vi 

# show all config
git config --list
