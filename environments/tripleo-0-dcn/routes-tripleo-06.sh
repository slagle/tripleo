#!/bin/bash

set -eux

# Routes to virt networks on tripleo-05
sudo ip route add 172.16.220.0/24 via 10.19.56.13
sudo ip route add 10.0.220.0/24 via 10.19.56.13
sudo ip route add 192.168.220.0/24 via 10.19.56.13

# Route to InternalApi on tripleo0-05
sudo ip route add 172.25.1.0/24 via 10.19.56.13
