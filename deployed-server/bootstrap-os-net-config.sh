#!/bin/bash

set -eux

yum -y install git
if [ ! -d tripleo-ci ]; then
    git clone https://git.openstack.org/openstack-infra/tripleo-ci
fi
tripleo-ci/scripts/tripleo.sh --repo-setup
yum -y install openvswitch
systemctl enable openvswitch
systemctl start openvswitch

curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
if [ ! -d os-net-config ]; then
    git clone https://git.openstack.org/openstack/os-net-config
fi
cd os-net-config
git config --global user.name "Your Name"
git config --global user.email you@example.com
git reset --hard origin/master
git fetch https://git.openstack.org/openstack/os-net-config refs/changes/15/304215/5 && git cherry-pick FETCH_HEAD
yum -y install gcc python-devel
pip install -e .
cd

