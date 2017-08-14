#!/bin/bash

set -eux

export TEMPLATES="/home/stack/tripleo-heat-templates"
export ENVIRONMENTS="\
  -e /home/stack/containers/role-counts.yaml \
  -e $TEMPLATES/environments/docker.yaml \
  -e $TEMPLATES/environments/docker-ha.yaml \
  -e /home/stack/containers/container-env-images.yaml \
  -e /home/stack/containers/containers-environment.yaml \
"
export ROLES_DATA="/home/stack/containers/roles_data.yaml"

/home/stack/tripleo/scripts/deploy.sh $@
