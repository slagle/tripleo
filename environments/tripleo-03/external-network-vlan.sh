#!/bin/bash

set -eux

ip link add link virbr0 name vlan10 type vlan id 10
ip addr add 10.0.0.1/24 dev vlan10
ip link set dev vlan10 up
