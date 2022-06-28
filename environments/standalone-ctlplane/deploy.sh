#!/bin/bash

set -eux

SCRIPT_DIR=$(realpath $(dirname $0))

export ROLES_FILE="$HOME/tripleo-heat-templates/roles/Controller.yaml"

${SCRIPT_DIR}/../standalone-master/deploy.sh
