#!/bin/bash

set -eux

time openstack overcloud deploy \
	--stack overcloud-services \
	--disable-validations \
	--templates tripleo-heat-templates \
	-r services-roles-data.yaml \
	-e tripleo-heat-templates/overcloud-resource-registry-puppet.yaml \
	-e tripleo-heat-templates/environments/puppet-pacemaker.yaml \
	-e tripleo-heat-templates/environments/puppet-ceph.yaml \
	-e tripleo-heat-templates/environments/enable-swap.yaml \
	-e tripleo-heat-templates/environments/deployed-server-environment.yaml \
	-e tripleo-heat-templates/environments/deployed-server-pacemaker-environment.yaml \
	-e overcloud-services.yaml \
	-e deployed-server-environment-output.json \
	-e network-isolation.yaml \
	-e role-counts.yaml \
	-e network-environment.yaml \
	-e ntp-environment.yaml
