#!/bin/bash

openstack port list | grep 97137450-073a-477b-b100-463dd90ec911 | grep -E '192.168.1.(100-102)'
openstack port list | grep 7e4ceb14-1e34-48e7-a0ef-eabf748c79e6 | grep -E '192.168.24.(100-102)'

openstack port create --fixed-ip ip-address=192.168.24.49 --network jslagle-master control-virtual-ip &
openstack port delete control-virtual-ip &

for i in 0 1 2; do
    openstack server delete controller-${i} &
    openstack port delete controller-${i}-test &
    openstack port delete controller-${i}-master &
done

function create {
    name=$1
    ip=$2
    index=$3
    flavor=$4

    openstack port create \
        --fixed-ip ip-address=192.168.1.${ip} \
        --network jslagle-test \
        ${name}-${index}-test
    test_port_id=$(openstack port show ${name}-${index}-test -f value -c id)

    openstack port create \
        --fixed-ip ip-address=192.168.24.${ip} \
        --network jslagle-master \
        ${name}-${index}-master
    master_port_id=$(openstack port show ${name}-${index}-master -f value -c id)

    openstack server create \
        --flavor $flavor \
        --image RHEL-8.1.1-x86_64-latest \
        --key-name jslagle \
        --nic port-id=$test_port_id \
        --nic port-id=$master_port_id \
        ${name}-${index}
}

for i in 0 1 2; do
    ip=$((46 + $i))
    create controller $ip $i m1.large &
done

for i in 66 71 81; do
    openstack port delete compute-${i}-test &
    openstack port delete compute-${i}-master &
done

for i in $(seq 0 49); do
    openstack server delete compute-${i} &
    openstack port delete compute-${i}-test &
    openstack port delete compute-${i}-master &
done

for i in $(seq 0 49); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.micro &
done

for i in $(seq 0 49); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.medium &
done

for i in $(seq 50 99); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.medium &
done

for i in $(seq 100 149); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.medium &
done

for i in $(seq 150 199); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.medium &
done

for i in $(seq 0 9); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.micro &
done

for i in $(seq 10 19); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.micro &
done

for i in $(seq 20 29); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.micro &
done

for i in $(seq 30 39); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.micro &
done

for i in $(seq 50 99); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.micro &
done

for i in 0 1 2; do
    openstack server rebuild --image RHEL-8.1.1-x86_64-latest controller-${i} &
done

for i in $(seq 0 49); do
    openstack server rebuild --image RHEL-8.1.1-x86_64-latest compute-${i} &
done

for i in $(seq 50 99); do
    openstack server rebuild --image RHEL-8.1.1-x86_64-latest compute-${i} &
done

for i in $(seq 100 149); do
    openstack server rebuild --image RHEL-8.1.1-x86_64-latest compute-${i} &
done

for i in $(seq 0 99); do
    openstack server rebuild --image RHEL-8.1.1-x86_64-latest compute-${i} &
done
