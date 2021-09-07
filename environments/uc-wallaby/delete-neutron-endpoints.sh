#!/bin/bash

set -eux

openstack endpoint list | grep neutron | awk '{print $2;}' | xargs -t openstack endpoint delete
openstack service delete neutron
