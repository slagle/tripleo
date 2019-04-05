#!/bin/bash

set -eux

# InternalAPIDCN1 gateway
sudo ip link add link dcn1-management name dcn1.1175 type vlan id 1175
sudo ip a add 172.25.2.254/24 dev dcn1.1175
sudo ip link set dev dcn1.1175 up
