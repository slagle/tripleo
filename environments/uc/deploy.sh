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
    --roles-data /home/stack/tripleo/environments/master-upshift/roles-data.yaml \
    --network-data /home/stack/tripleo/environments/master-upshift/network-data.yaml \
    --overcloud-ssh-network management \
    --overcloud-ssh-user centos \
    --overcloud-ssh-key ~/.ssh/upshift \
	# needed as OS::TripleO::Server is still mapped to OS::Nova::Server by default
    -e /home/stack/tripleo-heat-templates/environments/deployed-server-environment.yaml \
    -e /home/stack/tripleo-heat-templates/environments/deployed-network-environment.yaml \
    -e /home/stack/tripleo/environments/passwords.yaml \
    -e /home/stack/tripleo/environments/containers-tripleomaster-current-tripleo.yaml \
    -e /home/stack/tripleo/environments/glance-backend-file.yaml \
    -e /home/stack/tripleo/environments/master-upshift/role-counts.yaml \
    -e /home/stack/tripleo/environments/master-upshift/hostnamemap.yaml \
    -e /home/stack/tripleo/environments/master-upshift/network-environment.yaml \
    -e /home/stack/tripleo/environments/uc/deployed-server-network-environment.yaml \
    $@
