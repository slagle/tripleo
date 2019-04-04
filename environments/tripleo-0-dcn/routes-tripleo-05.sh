#!/bin/bash

set -eux

sudo ip route add 172.16.221.0/24 via 10.19.56.9
sudo ip route add 10.0.221.0/24 via 10.19.56.9
sudo ip route add 192.168.221.0/24 via 10.19.56.9

sudo ip route add 172.16.222.0/24 via 10.19.56.15
sudo ip route add 10.0.222.0/24 via 10.19.56.15
sudo ip route add 192.168.222.0/24 via 10.19.56.15
