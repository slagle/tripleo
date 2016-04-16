#!/bin/bash

set -eux

yum -y install git

git config --global user.name "Your Name"
git config --global user.email you@example.com

git clone https://git.openstack.org/openstack-infra/tripleo-ci
tripleo-ci/scripts/tripleo.sh --repo-setup
sudo yum -y install instack-undercloud
cp ~/deployed-server/config.json.template /usr/share/instack-undercloud/undercloud-stack-config/config.json.template
tripleo-ci/scripts/tripleo.sh --undercloud


