#!/bin/bash

set -eux

# InternalAPIDCN2 gateway
sudo ip link add link dcn2-management name dcn2.1165 type vlan id 1165
sudo ip a add 172.25.3.254/24 dev dcn1.1165
sudo ip link set dev dcn2.1165 up
