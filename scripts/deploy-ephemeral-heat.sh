#!/bin/bash

set -eux

# Working directory assumed to be current directory unless otherwise
# overridden.
WORK_DIR=${WORK_DIR:-"$(pwd)"}
REPOS="
    python-tripleoclient
    tripleo-common
    tripleo-ansible
    tripleo-heat-templates
"

cd $WORK_DIR

# Git repos are not overridden if they already exist
if [ ! -d python-tripleoclient ]; then
    git clone https://opendev.org/openstack/python-tripleoclient
    git fetch "https://review.opendev.org/openstack/python-tripleoclient" refs/changes/84/769984/4
    git checkout -b ephemeral-heat FETCH_HEAD
fi

if [ ! -d tripleo-common ]; then
    git clone https://opendev.org/openstack/tripleo-common
    git fetch "https://review.opendev.org/openstack/tripleo-common" refs/changes/84/769984/4
    git checkout -b ephemeral-heat FETCH_HEAD
fi

if [ ! -d tripleo-ansible ]; then
    git clone https://opendev.org/openstack/tripleo-ansible
    git fetch "https://review.opendev.org/openstack/tripleo-ansible" refs/changes/83/769983/2
    git checkout -b ephemeral-heat FETCH_HEAD
fi

if [ ! -d tripleo-heat-templates ]; then
    git clone https://opendev.org/openstack/tripleo-heat-templates
    git fetch "https://review.opendev.org/openstack/tripleo-heat-templates" refs/changes/56/769856/2
    git checkout -b ephemeral-heat FETCH_HEAD
fi

for repo in $REPOS; do
    pushd repo
    sudo /usr/bin/python3 setup.py install -f --prefix /usr
    popd
done

cat > $WORK_DIR/ephemeral-heat-environment.yaml<<EOF
resource_registry:
  OS::TripleO::DeployedServer::ControlPlanePort: $WORK_DIR/tripleo-heat-templates/deployed-server/deployed-neutron-port.yaml
  OS::TripleO::Network::Ports::ControlPlaneVipPort: $WORK_DIR/tripleo-heat-templates/deployed-server/deployed-neutron-port.yaml
  OS::TripleO::Network::Ports::RedisVipPort: $WORK_DIR/tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::Network::Ports::OVNDBsVipPort: $WORK_DIR/tripleo-heat-templates/network/ports/noop.yaml

parameter_defaults:

  SshFirewallAllowAll: true
  NeutronPublicInterface: eth0

  EC2MetadataIp: 192.168.1.1
  ControlPlaneDefaultRoute: 192.168.1.1
  NtpServer:
    - clock.redhat.com
    - clock2.redhat.com
  DnsServers:
    - 10.11.5.19
    - 10.5.30.160

  HostnameMap:
	overcloud-controller-0: ephemeral-heat-controller-0
	overcloud-novacompute-0: ephemeral-heat-compute-0

  DeployedServerPortMap:
    control_virtual_ip:
      fixed_ips:
        - ip_address: 192.168.1.39
      subnets:
        - cidr: 192.168.1.0/24
      network:
        tags:
          - 192.168.1.0/24
    ephemeral-heat-controller-0-ctlplane:
      fixed_ips:
        - ip_address: 192.168.1.51
      subnets:
        - cidr: 192.168.1.0/24
      network:
        tags:
          - 192.168.1.0/24
    ephemeral-heat-novacompute-0-ctlplane:
      fixed_ips:
        - ip_address: 192.168.1.46
      subnets:
        - cidr: 192.168.1.0/24
      network:
        tags:
          - 192.168.1.0/24

EOF

openstack overcloud deploy \
    --stack overcloud \
    --templates $WORK_DIR/tripleo-heat-templates \
    --deployed-server \
    --disable-validations \
    --overcloud-ssh-user centos \
    --overcloud-ssh-key '~/.ssh/upshift' \
    -e /home/centos/tripleo-heat-templates/environments/deployed-server-environment.yaml \
	-e @$WORK_DIR/ephemeral-heat-environment.yaml \
	--tripleo-deploy
