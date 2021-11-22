#!/bin/bash

set -eux 

sshuttle -r 10.0.126.77 -e "ssh -i ~/.ssh/upshift -l centos" 172.16.5.0/24
