#!/bin/bash

set -eux

openstack baremetal node set --property root_device='{"name":"/dev/vda"}' core-compute-0
openstack baremetal node set --property root_device='{"name":"/dev/vda"}' core-compute-1
openstack baremetal node set --property root_device='{"name":"/dev/vda"}' core-compute-2
