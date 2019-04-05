#!/bin/bash

set -eux

# InternalAPI gateway
ip link add link core-management name core.1185 type vlan id 1185
ip addr add 172.25.1.254 dev core.1185
ip link set dev core.1185 up
