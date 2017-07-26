#!/bin/bash

set -eux

export HEATCLIENT=1
export STACK_NAME=cinder-standalone
export ROLES_DATA=$TEMPLATES/roles_data_undercloud.yaml
export COMMON_ENVIRONMENTS=0
dir=$(dirname $0)

export ENVIRONMENTS="\
    -e $TEMPLATES/overcloud-resource-registry-puppet.yaml \
    -e $TEMPLATES/environments/undercloud.yaml \
    -e $TEMPLATES/environments/docker.yaml \
    -e $dir/cinder-standalone.yaml"

deploy.sh
