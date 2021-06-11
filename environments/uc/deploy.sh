#!/bin/bash

set -eux

source stackrc

openstack overcloud deploy \
    --stack overcloud \
    --templates /home/stack/tripleo-heat-templates \
    --deployed-server \
    --disable-validations \
    --heat-type pod  \
    --skip-heat-pull \
    -r /home/stack/tripleo/environments/master-upshift/roles-data.yaml \
    -n /home/stack/tripleo/environments/master-upshift/network_data.yaml \
    -e /home/stack/tripleo-heat-templates/environments/deployed-server-environment.yaml \
    -e /home/stack/tripleo-heat-templates/environments/network-isolation.yaml \
    -e /home/stack/tripleo/environments/passwords.yaml \
    -e /home/stack/tripleo/environments/master-upshift/role-counts.yaml \
    -e /home/stack/tripleo/environments/master-upshift/hostnamemap.yaml \
    -e /home/stack/tripleo/environments/master-upshift/network-environment.yaml \
    -e /home/stack/tripleo/environments/master-upshift/deployed-server-port-map.yaml \
    -e /home/stack/tripleo/environments/containers-tripleomaster-current-tripleo.yaml \
    -e /home/stack/tripleo/environments/glance-backend-file.yaml \
    -e /home/stack/tripleo/environments/ovn-mac-address-network-noop.yaml \
    -e /home/stack/overcloud-baremetal-deployed.yaml \
    -e /home/stack/overcloud-network-deployed.yaml \
    -e /home/stack/overcloud-vip-deployed.yaml \
    --overcloud-ssh-network management \
    --overcloud-ssh-user centos \
    --overcloud-ssh-key ~/.ssh/upshift \
    $@
