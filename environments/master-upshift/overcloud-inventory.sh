#!/bin/bash

set -eux

tripleo-ansible-inventory \
    --ansible_ssh_user centos \
    --static-yaml-inventory ~/overcloud-inventory.yaml \
    --stack $STACK_NAME
