#!/bin/bash

set -eux

export IP=192.168.24.2
export NETMASK=24
export INTERFACE=eno3
export GATEWAY=10.19.59.254

cat <<EOF > $HOME/standalone_parameters.yaml
parameter_defaults:
  CloudName: $IP
  # ControlPlaneStaticRoutes: []
  Debug: true
  DeploymentUser: $USER
  DnsServers:
    - 10.16.36.29
    - 10.11.5.19
    # - 1.1.1.1
    # - 8.8.8.8
  DockerInsecureRegistryAddress:
    - $IP:8787
  NeutronPublicInterface: $INTERFACE
  # domain name used by the host
  NeutronDnsDomain: localdomain
  # re-use ctlplane bridge for public net, defined in the standalone
  # net config (do not change unless you know what you're doing)
  NeutronBridgeMappings: datacentre:br-ctlplane
  NeutronPhysicalBridge: br-ctlplane
  # enable to force metadata for public net
  #NeutronEnableForceMetadata: true
  StandaloneEnableRoutedNetworks: false
  StandaloneHomeDir: $HOME
  StandaloneLocalMtu: 1500
  # Needed if running in a VM, not needed if on baremetal
  # NovaComputeLibvirtType: qemu

  ControlPlaneStaticRoutes:
    - ip_netmask: 0.0.0.0/0
      next_hop: $GATEWAY
      default: true

  NtpServer: clock.redhat.com

EOF

sudo openstack tripleo deploy \
  --templates \
  --local-ip=$IP/$NETMASK \
  -e /usr/share/openstack-tripleo-heat-templates/environments/standalone/standalone-tripleo.yaml \
  -r /usr/share/openstack-tripleo-heat-templates/roles/Standalone.yaml \
  -e $HOME/containers-prepare-parameters.yaml \
  -e $HOME/standalone_parameters.yaml \
  --output-dir $HOME \
  --standalone \
  --keep-running

