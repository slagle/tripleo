#!/bin/bash

set -eux

source ~/stackrc
openstack overcloud deploy \
  --templates \
  --disable-validations \
  -e /usr/share/openstack-tripleo-heat-templates/environments/deployed-server-environment.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/deployed-server-bootstrap-environment-rhel.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
  -e network-environment-multiple-nics.yaml \
  -e role-counts.yaml \
  -r deployed-server-roles-data.yaml
