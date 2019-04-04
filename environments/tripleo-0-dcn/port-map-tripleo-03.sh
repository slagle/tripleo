#!/bin/bash

set -eux

openstack baremetal node manage dcn1-compute-0
openstack baremetal node manage dcn1-compute-1
openstack baremetal node manage dcn1-compute-2

uuid=$(openstack baremetal port list --node dcn1-compute-0 -f value -c UUID)
openstack baremetal port set --physical-network leaf1 $uuid

uuid=$(openstack baremetal port list --node dcn1-compute-1 -f value -c UUID)
openstack baremetal port set --physical-network leaf1 $uuid

uuid=$(openstack baremetal port list --node dcn1-compute-2 -f value -c UUID)
openstack baremetal port set --physical-network leaf1 $uuid

openstack baremetal node manage dcn1-compute-0
openstack baremetal node manage dcn1-compute-1
openstack baremetal node manage dcn1-compute-2
