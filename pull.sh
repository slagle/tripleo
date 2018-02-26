#!/bin/bash

set -eux

cd $HOME/tripleo
git pull --rebase --autostash
cd -
