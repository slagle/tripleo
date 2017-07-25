#!/bin/bash

set -eux

STEP=${1:-4}

sed -i 's/LOG.debug/LOG.info/' /usr/lib/python2.7/site-packages/paunch/runner.py
paunch --debug apply --file /var/lib/tripleo-config/docker-container-startup-config-step_${STEP}.json --config-id tripleo_step${STEP} --managed-by tripleo-config
