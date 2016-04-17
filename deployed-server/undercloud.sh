#!/bin/bash

set -eux

sudo yum -y install git

if [ ! -d tripleo ]; then
    git clone https://github.com/slagle/tripleo
fi
ln -s -f tripleo/deployed-server

if [ ! -d tripleo-ci ]; then
    git clone https://git.openstack.org/openstack-infra/tripleo-ci
fi

tripleo-ci/scripts/tripleo.sh --repo-setup
sudo yum -y install instack-undercloud
sudo cp ~/deployed-server/config.json.template /usr/share/instack-undercloud/undercloud-stack-config/config.json.template
tripleo-ci/scripts/tripleo.sh --undercloud


if [ ! -d python-tripleoclient ]; then
    git clone https://git.openstack.org/openstack/python-tripleoclient
fi
pushd python-tripleoclient
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git reset --hard origin/master
git fetch https://git.openstack.org/openstack/python-tripleoclient refs/changes/45/305845/1 && git cherry-pick FETCH_HEAD
git fetch https://git.openstack.org/openstack/python-tripleoclient refs/changes/60/306060/1 && git cherry-pick FETCH_HEAD
sudo pip install -e .
popd

pushd ~/deployed-server
if [ ! -d tripleo-heat-templates ]; then
    git clone https://git.openstack.org/openstack/tripleo-heat-templates
fi
pushd tripleo-heat-templates
git reset --hard origin/master
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/66/301266/2 && git cherry-pick FETCH_HEAD
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/67/301267/2 && git cherry-pick FETCH_HEAD
git fetch https://git.openstack.org/openstack/tripleo-heat-templates refs/changes/72/222772/10 && git cherry-pick FETCH_HEAD
popd
popd

curl -L -O http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
glance image-create --file cirros-0.3.4-x86_64-disk.img --progress --disk-format qcow2 --container-format bare --name overcloud-full
