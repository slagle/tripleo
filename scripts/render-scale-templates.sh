#!/bin/bash

set -eux

ansible -c local localhost -m template -a "src=tripleo/environments/deployed-server-port-map.j2.yaml dest=deployed-server-port-map.yaml"
ansible -c local localhost -m template -a "src=tripleo/environments/hostname-map.j2.yaml dest=hostname-map.yaml"
