#!/bin/bash

set -eux

export TEMPLATES="$HOME/tripleo-heat-templates"
export ENVIRONMENTS="\
  -e $TEMPLATES/environments/deployed-server-environment.yaml \
  -e $TEMPLATES/environments/deployed-server-bootstrap-environment-centos.yaml \
  -e $TEMPLATES/environments/docker.yaml \
  -e $TEMPLATES/environments/docker-ha.yaml \
  -e $HOME/tripleo/environments/containers-split-stack/role-counts.yaml \
  -e $HOME/tripleo/environments/containers-split-stack/network-environment.yaml \
  -e $HOME/tripleo/environments/containers-split-stack/container-env-images.yaml \
  -e $HOME/tripleo/environments/containers-split-stack/containers-environment.yaml \
  -e $HOME/tripleo/environments/containers-split-stack/deployment-swift-data-map.yaml \
"
export ROLES_DATA="$HOME/tripleo/environments/containers-split-stack/roles_data.yaml"

$HOME/tripleo/scripts/deploy.sh $@
