#!/bin/bash

set -eux

export IP=192.168.24.2
export VIP=192.168.24.3
export NETMASK=24
export INTERFACE=eth1

if [ ! -f /home/stack/containers-prepare-parameters.yaml ]; then
    openstack tripleo container image prepare default --output-env-file /home/stack/containers-prepare-parameters.yaml
fi

sudo openstack tripleo deploy \
    --templates $HOME/tripleo-heat-templates \
    --local-ip=$IP/$NETMASK \
    --control-virtual-ip $VIP \
    -e $HOME/tripleo-heat-templates/environments/standalone/standalone-tripleo.yaml \
    -r $HOME/tripleo-heat-templates/roles/Standalone.yaml \
    -e $HOME/tripleo/environments/standalone-master/containers-prepare-parameters.yaml \
    -e $HOME/tripleo/environments/standalone-master/standalone_parameters.yaml \
    -e $HOME/tripleo/environments/timezone-eastern.yaml \
    --standalone \
    $@
