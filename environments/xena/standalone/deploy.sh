#!/bin/bash

set -eux

export IP=192.168.24.2
export VIP=192.168.24.3
export NETMASK=24
export INTERFACE=eth1

sudo openstack tripleo deploy \
    --templates $HOME/tripleo-heat-templates \
    --local-ip=$IP/$NETMASK \
    --control-virtual-ip $VIP \
    -e $HOME/tripleo-heat-templates/environments/standalone/standalone-tripleo.yaml \
    -r $HOME/tripleo-heat-templates/roles/Standalone.yaml \
    -e $HOME/tripleo/environments/xena/standalone/containers-prepare-parameters.yaml \
    -e $HOME/tripleo/environments/xena/standalone/standalone_parameters.yaml \
    -e $HOME/tripleo/environments/timezone-eastern.yaml \
    --standalone \
    $@
