#!/bin/bash
set -eux

ansible-playbook \
    --forks 20 \
    -i tripleo/environments/osp16-upshift/inventory.yaml \
    tripleo/environments/osp16-upshift/bootstrap.yaml \
    $@
