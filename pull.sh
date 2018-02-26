#!/bin/bash

set -eux

cd $HOME/tripleo
git stash save
git pull --rebase
git stash pop
cd -
