#!/bin/bash

set -eux

source ~/stackrc
openstack overcloud deploy \
  --templates \
  --disable-validations \
  -e /usr/share/openstack-tripleo-heat-templates/environments/deployed-server-environment.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/deployed-server-bootstrap-environment-rhel.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml \
  -e network-environment.yaml \
  -e role-counts.yaml \
  -r deployed-server-roles-data.yaml
