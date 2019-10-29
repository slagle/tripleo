#!/bin/bash

set -eux

sshuttle -r cloud-user@10.0.126.1 02 --python /usr/libexec/platform-python 192.168.1.0/24
