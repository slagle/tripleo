#!/bin/bash

set -x
sudo ovs-vsctl del-br br-ex || :
sudo systemctl stop openvswitch
sudo rm -f /etc/openvswitch/conf.db
sudo bash -c "cat >/etc/sysconfig/network-scripts/ifcfg-eth0<<EOF
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
NM_CONTROLLED=no
EOF"
sudo rm -f /etc/sysconfig/network-scripts/ifcfg-br*

