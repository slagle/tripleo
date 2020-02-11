#!/bin/bash

set -eux

tripleo-ansible-inventory \
    --ansible_ssh_user cloud-user \
    --static-yaml-inventory ~/overcloud-inventory.yaml \
    --stack $STACK_NAME
