#!/bin/bash

set -eux

time openstack overcloud deploy \
	--stack overcloud-baremetal \
	--disable-validations \
	--templates tripleo-heat-templates \
	-r baremetal-roles-data.yaml \
	-e tripleo-heat-templates/overcloud-resource-registry-puppet.yaml \
	-e tripleo-heat-templates/environments/puppet-pacemaker.yaml \
	-e tripleo-heat-templates/environments/puppet-ceph.yaml \
	-e tripleo-heat-templates/environments/overcloud-baremetal.yaml \
	-e ntp-environment.yaml \
	-e role-counts.yaml
