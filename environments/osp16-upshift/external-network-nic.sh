#!/bin/bash

set -eux

NIC=${NIC:-eth2}

sudo ip addr add 10.0.0.1/24 dev $NIC
sudo ip link set dev $NIC up
sudo ip link set dev $NIC mtu 1400
