#!/bin/bash
set -eux

ansible-playbook \
    --forks 20 \
    -i tripleo/environments/osp16-scale-upshift/inventory.yaml \
    tripleo/environments/osp16-scale-upshift/bootstrap.yaml \
    $@
