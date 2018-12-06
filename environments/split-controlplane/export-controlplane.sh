#!/bin/bash

set -eux

export OS_CLOUD=undercloud
export DIR=export-control-plane
export STACK=${STACK:-"controlplane"}

mkdir -p $DIR

openstack stack output show $STACK EndpointMap --format json \
  | jq '{"parameter_defaults": {"EndpointMapOverride": .output_value}}' \
  > $DIR/endpoint-map.json

openstack stack output show $STACK AllNodesConfig --format json \
  | jq '{"parameter_defaults": {"AllNodesExtraMapData": .output_value}}' \
  > $DIR/all-nodes-extra-map-data.json

openstack stack output show $STACK HostsEntry -f json \
  | jq -r '{"parameter_defaults":{"ExtraHostFileEntries": .output_value}}' \
  > $DIR/extra-host-file-entries.json

cat >$DIR/oslo.yaml <<EOF
parameter_defaults:
  ComputeExtraConfig:
    oslo_messaging_notify_use_ssl: false
    oslo_messaging_rpc_use_ssl: false
EOF

sudo egrep "oslo.*password" /etc/puppet/hieradata/service_configs.json \
  | sed -e s/\"//g -e s/,//g >> $DIR/oslo.yaml

cp $HOME/tripleo-undercloud-passwords.yaml $DIR/passwords.yaml



