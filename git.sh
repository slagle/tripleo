#!/bin/bash

set -eux

MSG=${1:-"updates"}

git add -A .
git commit . -m "$MSG"; git push
