#!/bin/bash

set -eux

export TEMPLATES="/home/centos/tripleo-heat-templates"
export ENVIRONMENTS="\
  -e $TEMPLATES/environments/deployed-server-environment.yaml \
  -e $TEMPLATES/environments/deployed-server-bootstrap-environment-centos.yaml \
  -e /home/centos/containers/role-counts.yaml \
  -e /home/centos/containers/network-environment.yaml \
  -e $TEMPLATES/environments/docker.yaml \
  -e $TEMPLATES/environments/docker-ha.yaml \
  -e /home/centos/containers/container-env-images.yaml \
  -e /home/centos/containers/containers-environment.yaml \
  -e /home/centos/deployment-swift-data-map.yaml \
"
export ROLES_DATA="/home/centos/containers/roles_data.yaml"

/home/centos/tripleo/scripts/deploy.sh $@
