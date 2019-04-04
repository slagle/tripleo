#!/bin/bash

set -eux

openstack baremetal node manage dcn2-compute-0
openstack baremetal node manage dcn2-compute-1
openstack baremetal node manage dcn2-compute-2

uuid=$(openstack baremetal port list --node dcn2-compute-0 -f value -c UUID)
openstack baremetal port set --physical-network leaf2 $uuid

uuid=$(openstack baremetal port list --node dcn2-compute-1 -f value -c UUID)
openstack baremetal port set --physical-network leaf2 $uuid

uuid=$(openstack baremetal port list --node dcn2-compute-2 -f value -c UUID)
openstack baremetal port set --physical-network leaf2 $uuid

openstack baremetal node provide dcn2-compute-0
openstack baremetal node provide dcn2-compute-1
openstack baremetal node provide dcn2-compute-2
