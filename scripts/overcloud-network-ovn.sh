#!/bin/bash

set -eux

openstack network create --share --external --provider-network-type flat --provider-physical-network datacentre public
openstack subnet create --network public --subnet-range 10.0.0.10/24 --no-dhcp public-subnet

openstack network create --share --provider-network-type geneve private
openstack subnet create private-subnet --subnet-range 192.0.2.0/24 --network private

openstack router create default-router
openstack router add subnet default-router private-subnet
openstack router set --external-gateway public default-router
