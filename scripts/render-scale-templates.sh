#!/bin/bash

set -eux

file=$(mktemp)
sed -i "s/compute_count/$1" tripleo/environments/deployed-server-port-map.j2.yaml > $file
ansible -c local localhost -m template -a "src=$file dest=deployed-server-port-map.yaml"
ansible -c local localhost -m template -a "src=tripleo/environments/hostname-map.j2.yaml dest=hostname-map.yaml"
