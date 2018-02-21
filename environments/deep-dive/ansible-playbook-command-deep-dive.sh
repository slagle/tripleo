#!/bin/bash

set -eux

ansible-playbook -i ~/tripleo-ansible-inventory-deep-dive.yaml --become -u centos --private-key ~/deep-dive/id_rsa deploy_steps_playbook.yaml "$@"

