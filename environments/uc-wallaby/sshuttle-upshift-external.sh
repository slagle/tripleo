#!/bin/bash

set -eux 

sshuttle -r 10.0.126.77 -e "ssh -i ~/.ssh/upshift -l centos" 10.0.0.0/24
