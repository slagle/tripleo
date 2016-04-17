#!/bin/bash

set -eux

ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex tun0 -- set interface tun0 type=gre options:remote_ip=$remote_ip options:ttl=255
ip addr add $subnet_ip dev br-ex
ip link set dev br-ex up
