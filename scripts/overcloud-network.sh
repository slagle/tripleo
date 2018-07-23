#!/bin/bash

set -eux

neutron net-create --router:external \
--provider:physical_network datacentre \
--provider:network_type flat \
public

neutron subnet-create \
--name public-subnet \
--disable-dhcp \
--allocation-pool start=192.168.122.50,end=192.168.122.70 \
--gateway 192.168.122.1 \
public 192.168.122.0/24

##
# Also required:
# iptables -t nat -A POSTROUTING ! -s 127.0.0.0/8 -j MASQUERADE
##

neutron net-create private --shared --port-security-enabled False

neutron subnet-create \
--name private-subnet \
--allocation-pool start=192.0.2.10,end=192.0.2.20 \
--enable-dhcp \
--dns-nameserver 8.8.8.8 \
private 192.0.2.0/24

neutron router-create default-router
neutron router-interface-add default-router private-subnet
neutron router-gateway-set default-router public
neutron router-port-list default-router
