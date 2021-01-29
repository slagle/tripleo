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
SETUP_PY=${SETUP_PY:-"1"}
CONTROLLER_IP=${CONTROLLER_IP:-"192.168.1.51"}
COMPUTE_IP=${COMPUTE_IP:-"192.168.1.46"}
CONTROLPLANE_VIRTUAL_IP=${CONTROLPLANE_VIRTUAL_IP:-"192.168.1.39"}
CONTROLPLANE_SUBNET_CIDR=${CONTROLPLANE_SUBNET_CIDR:-"192.168.1.0/24"}
CONTROLPLANE_DEFAULT_ROUTE=${CONTROLPLANE_DEFAULT_ROUTE:-"192.168.1.1"}

cd $WORK_DIR

# Git repos are not overridden if they already exist
if [ ! -d python-tripleoclient ]; then
    git clone https://opendev.org/openstack/python-tripleoclient
    python-tripleoclient
    git fetch "https://review.opendev.org/openstack/python-tripleoclient" refs/changes/84/769984/4
    git checkout -b ephemeral-heat FETCH_HEAD
    popd
fi

if [ ! -d tripleo-common ]; then
    git clone https://opendev.org/openstack/tripleo-common
    pushd tripleo-common
    git fetch "https://review.opendev.org/openstack/tripleo-common" refs/changes/82/769982/4
    git checkout -b change-769982-4 FETCH_HEAD
    popd
fi

if [ ! -d tripleo-ansible ]; then
    git clone https://opendev.org/openstack/tripleo-ansible
    pushd tripleo-ansible
    git fetch "https://review.opendev.org/openstack/tripleo-ansible" refs/changes/83/769983/2
    git checkout -b ephemeral-heat FETCH_HEAD
    popd
fi

if [ ! -d tripleo-heat-templates ]; then
    git clone https://opendev.org/openstack/tripleo-heat-templates
    pushd tripleo-heat-templates
    git fetch "https://review.opendev.org/openstack/tripleo-heat-templates" refs/changes/56/769856/2
    git checkout -b ephemeral-heat FETCH_HEAD
    popd
fi

if [ "$SETUP_PY" = 1 ]; then
    for repo in $REPOS; do
        pushd $repo
        sudo /usr/bin/python3 setup.py install -f --prefix /usr
        popd
    done
fi

cat > $WORK_DIR/ephemeral-heat-environment.yaml<<EOF
resource_registry:
  OS::TripleO::DeployedServer::ControlPlanePort: $WORK_DIR/tripleo-heat-templates/deployed-server/deployed-neutron-port.yaml
  OS::TripleO::Network::Ports::ControlPlaneVipPort: $WORK_DIR/tripleo-heat-templates/deployed-server/deployed-neutron-port.yaml
  OS::TripleO::Network::Ports::RedisVipPort: $WORK_DIR/tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::Network::Ports::OVNDBsVipPort: $WORK_DIR/tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::OVNMacAddressNetwork: OS::Heat::None
  OS::TripleO::OVNMacAddressPort: OS::Heat::None

parameter_defaults:
  SshFirewallAllowAll: true
  NeutronPublicInterface: eth0
  SoftwareConfigTransport: POLL_SERVER_HEAT

  EC2MetadataIp: $CONTROLPLANE_DEFAULT_ROUTE
  ControlPlaneDefaultRoute: $CONTROLPLANE_DEFAULT_ROUTE
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
        - ip_address: $CONTROLPLANE_VIRTUAL_IP
      subnets:
        - cidr: $CONTROLPLANE_SUBNET_CIDR
      network:
        tags:
          - $CONTROLPLANE_SUBNET_CIDR
    ephemeral-heat-controller-0-ctlplane:
      fixed_ips:
        - ip_address: $CONTROLLER_IP
      subnets:
        - cidr: $CONTROLPLANE_SUBNET_CIDR
      network:
        tags:
          - $CONTROLPLANE_SUBNET_CIDR
    ephemeral-heat-novacompute-0-ctlplane:
      fixed_ips:
        - ip_address: $COMPUTE_IP
      subnets:
        - cidr: $CONTROLPLANE_SUBNET_CIDR
      network:
        tags:
          - $CONTROLPLANE_SUBNET_CIDR

EOF

openstack overcloud deploy \
    --stack overcloud \
    --templates $WORK_DIR/tripleo-heat-templates \
    --deployed-server \
    --disable-validations \
    --overcloud-ssh-user centos \
    --overcloud-ssh-key '~/.ssh/upshift' \
    -e $WORK_DIR/tripleo-heat-templates/environments/deployed-server-environment.yaml \
    -e $WORK_DIR/ephemeral-heat-environment.yaml \
    --tripleo-deploy
