#!/bin/bash
set -eux

export ANSIBLE_CONFIG=~/ansible.cfg
cd ~/overcloud-config-download
ansible-playbook \
    --become \
    -i ~/overcloud-inventory.yaml \
    deploy_steps_playbook.yaml \
    $@
