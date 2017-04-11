#!/bin/bash

set -eux

export OVERCLOUD_ROLES="ControllerDeployedServer ComputeDeployedServer" 
export ControllerDeployedServer_hosts="192.0.2.22 192.0.2.32 192.0.2.31"
export ComputeDeployedServer_hosts="192.0.2.23"

/usr/share/openstack-tripleo-heat-templates/deployed-server/scripts/get-occ-config.sh 

