#!/bin/bash

set -eux 

sshuttle -r 10.0.126.77 -e "ssh -i ~/.ssh/upshift -l centos" 192.168.1.0/24 
