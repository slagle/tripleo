#!/bin/bash

set -eux

sudo ip route add 172.16.220.0/24 via 10.19.56.13
sudo ip route add 10.0.220.0/24 via 10.19.56.13
sudo ip route add 192.168.220.0/24 via 10.19.56.13
