#!/bin/bash

set -eux

file=$(mktemp)
sed "s/compute_count/$1/" tripleo/environments/deployed-server-port-map.j2.yaml > $file
ansible -c local localhost -m template -a "src=$file dest=deployed-server-port-map.yaml"
sed "s/compute_count/$1/" tripleo/environments/hostname-map.j2.yaml > $file
ansible -c local localhost -m template -a "src=$file dest=hostname-map.yaml"
rm -f $file

cp tripleo/environments/role-counts.j2.yaml role-counts.yaml
sed -i "s/compute_count/$1/" role-counts.yaml
