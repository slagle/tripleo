#!/bin/bash

set -eux

sudo yum -y install git

if [ ! -d tripleo-ci ]; then
    git clone https://git.openstack.org/openstack-infra/tripleo-ci
fi

tripleo-ci/scripts/tripleo.sh --repo-setup
sudo yum -y install instack-undercloud
sudo cp ~/deployed-server/config.json.template /usr/share/instack-undercloud/undercloud-stack-config/config.json.template
tripleo-ci/scripts/tripleo.sh --undercloud
