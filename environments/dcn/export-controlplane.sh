#!/bin/bash

set -eux

export OS_CLOUD=undercloud
export STACK=${STACK:-"controlplane"}
export DIR=${STACK}-export

mkdir -p $DIR

openstack stack output show $STACK EndpointMap --format json \
  | jq '{"parameter_defaults": {"EndpointMapOverride": .output_value}}' \
  > $DIR/endpoint-map.json

openstack stack output show $STACK AllNodesConfig --format json \
  | jq '{"parameter_defaults": {"AllNodesExtraMapData": .output_value}}' \
  > $DIR/all-nodes-extra-map-data.json

openstack stack output show $STACK GlobalConfig --format json \
  | jq '{"parameter_defaults": {"GlobalConfigExtraMapData": .output_value}}' \
  > $DIR/global-config-extra-map-data.json

openstack stack output show $STACK HostsEntry -f json \
  | jq -r '{"parameter_defaults":{"ExtraHostFileEntries": .output_value}}' \
  > $DIR/extra-host-file-entries.json

cat >$DIR/oslo.yaml <<EOF
parameter_defaults:
  ComputeExtraConfig:
    oslo_messaging_notify_use_ssl: false
    oslo_messaging_rpc_use_ssl: false
EOF

openstack object save $STACK plan-environment.yaml
python -c "import yaml; data=yaml.safe_load(open('plan-environment.yaml').read()); print yaml.dump(dict(parameter_defaults=data['passwords']))" > $DIR/passwords.yaml

