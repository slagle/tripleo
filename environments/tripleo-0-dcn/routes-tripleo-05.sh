#!/bin/bash

set -eux

# Routes to virt networks on tripleo-03
sudo ip route add 172.16.221.0/24 via 10.19.56.9
sudo ip route add 10.0.221.0/24 via 10.19.56.9
sudo ip route add 192.168.221.0/24 via 10.19.56.9

# Routes to virt networks on tripleo-06
sudo ip route add 172.16.222.0/24 via 10.19.56.15
sudo ip route add 10.0.222.0/24 via 10.19.56.15
sudo ip route add 192.168.222.0/24 via 10.19.56.15

# Route to InternalAPIDCN1 on tripleo-03
sudo ip route add 172.25.2.0/24 via 10.19.56.9
