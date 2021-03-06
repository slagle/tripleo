#!/bin/bash
set -eux

export ANSIBLE_CONFIG=~/ansible.cfg
cd ~/overcloud-config-download
time ansible-playbook \
    --become \
    -i ~/overcloud-inventory.yaml \
    --private-key ~/.ssh/upshift \
    deploy_steps_playbook.yaml \
    $@
