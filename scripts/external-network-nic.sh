#!/bin/bash

set -eux

NIC=${NIC:-eth1}

sudo ip addr add 10.0.0.10/24 dev $NIC
sudo ip link set dev $NIC up
