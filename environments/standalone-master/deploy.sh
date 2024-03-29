#!/bin/bash

set -eux

export IP=192.168.24.2
export VIP=192.168.24.3
export NETMASK=24
export INTERFACE=eth1
export ROLE=${ROLE:-"Standalone"}
export ROLES_FILE=${ROLES_FILE:-"$HOME/tripleo-heat-templates/roles/${ROLE}.yaml"}

if [ ! -f /home/stack/containers-prepare-parameters.yaml ]; then
    openstack tripleo container image prepare default --output-env-file $HOME/containers-prepare-parameters.yaml
fi

sudo openstack tripleo deploy \
    --templates $HOME/tripleo-heat-templates \
    --local-ip=$IP/$NETMASK \
    --control-virtual-ip $VIP \
    -e $HOME/tripleo-heat-templates/environments/standalone/standalone-tripleo.yaml \
    -r ${ROLES_FILE} \
    --standalone-role ${ROLE} \
    -e $HOME/containers-prepare-parameters.yaml \
    -e $HOME/tripleo/environments/standalone-master/standalone_parameters.yaml \
    -e $HOME/tripleo/environments/timezone-eastern.yaml \
    $@
