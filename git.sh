#!/bin/bash

set -eux

git add -A .
git commit . -m "updates"; git push
