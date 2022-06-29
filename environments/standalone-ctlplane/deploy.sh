#!/bin/bash

set -eux

SCRIPT_DIR=$(realpath $(dirname $0))

export ROLES_FILE="$HOME/tripleo-heat-templates/roles/Controller.yaml"
export ROLE="Controller"

${SCRIPT_DIR}/../standalone-master/deploy.sh -e ${SCRIPT_DIR}/standalone-ctlplane-parameters.yaml
