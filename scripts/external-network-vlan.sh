#!/bin/bash

set -ux

sudo ovs-vsctl add-port br-ctlplane vlan10 tag=10 -- set interface vlan10 type=internal
sudo ip l set dev vlan10 up; sudo ip addr add 10.0.0.1/24 dev vlan10
sudo iptables -A BOOTSTACK_MASQ -s 10.0.0.0/24 ! -d 10.0.0.0/24 -j MASQUERADE -t nat
