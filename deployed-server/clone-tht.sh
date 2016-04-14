#!/bin/bash

set -eux

if [ ! -d tripleo-heat-templates ]; then
    git clone https://git.openstack.org/openstack/tripleo-heat-templates
fi

pushd tripleo-heat-templates
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/72/222772/10 && git cherry-pick FETCH_HEAD
popd
