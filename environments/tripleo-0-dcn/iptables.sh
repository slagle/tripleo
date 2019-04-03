#!/bin/bash

set -ux

# iptables -t nat -A POSTROUTING --protocol all -s 192.168.220.0/24 ! -d 192.168.220.0/24 -j MASQUERADE
# sudo iptables -I FORWARD -s 10.0.220.0/24 -d 10.0.221.0/24 -j ACCEPT
# sudo iptables -I FORWARD -d 10.0.220.0/24 -s 10.0.221.0/24 -j ACCEPT
# sudo iptables -I FORWARD -s 192.168.221.0/24 -d 192.168.220.0/24 -j ACCEPT
# sudo iptables -I FORWARD -d 192.168.221.0/24 -s 192.168.220.0/24 -j ACCEPT
sudo iptables -I FORWARD -j ACCEPT
sudo iptables -t nat -A POSTROUTING -j MASQUERADE


