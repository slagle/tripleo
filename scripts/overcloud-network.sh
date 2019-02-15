#!/bin/bash

set -eux

# neutron net-create --router:external \
# --provider:physical_network datacentre \
# --provider:network_type flat \
# public

openstack network create --share --external --provider-network-type flat --provider-physical-network datacentre public

# neutron subnet-create \
# --name public-subnet \
# --disable-dhcp \
# --allocation-pool start=192.168.122.50,end=192.168.122.70 \
# --gateway 192.168.122.1 \
# public 192.168.122.0/24

openstack subnet create --network public --subnet-range 10.0.0.10/24 --no-dhcp public-subnet

##
# Also required:
# iptables -t nat -A POSTROUTING ! -s 127.0.0.0/8 -j MASQUERADE
##

# neutron net-create private --shared --port-security-enabled False

openstack network create --share --provider-network-type vxlan private

# neutron subnet-create \
# --name private-subnet \
# --allocation-pool start=192.0.2.10,end=192.0.2.20 \
# --enable-dhcp \
# --dns-nameserver 8.8.8.8 \
# private 192.0.2.0/24

openstack subnet create private-subnet --subnet-range 192.0.2.0/24 --network private

# neutron router-create default-router
# neutron router-interface-add default-router private-subnet
# neutron router-gateway-set default-router public
# neutron router-port-list default-router

openstack router create default-router
openstack router add subnet default-router private-subnet
openstack router set --external-gateway public default-router

