#!/bin/bash

set -eux

ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex eth1
ovs-vsctl add-port br-ex br-tun-patch -- set interface br-tun-patch type=patch options:peer=br-ex-patch
ip addr del $local_ip dev eth1
ip addr add $local_ip dev br-ex

ovs-vsctl add-br br-tun
ovs-vsctl add-port br-tun tun0 -- set interface tun0 type=gre options:remote_ip=${remote_ip:0:14} options:ttl=255
ovs-vsctl add-port br-tun br-ex-patch -- set interface br-ex-patch type=patch options:peer=br-tun-patch
ovs-vsctl add-port br-tun tep0 -- set interface tep0 type=internal
ip addr add $subnet_ip dev tep0

ip link set dev br-ex up
ip link set dev br-tun up
ip link set dev tep0 up
