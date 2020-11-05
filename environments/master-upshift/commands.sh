#!/bin/bash

openstack network create --internal --disable-port-security jslagle-master-ctlplane &
openstack network create --internal --disable-port-security jslagle-master-external &
openstack network create --internal --disable-port-security jslagle-master-internalapi &
openstack network create --internal --disable-port-security jslagle-master-storage &
openstack network create --internal --disable-port-security jslagle-master-storagemgt &
openstack network create --internal --disable-port-security jslagle-master-tenant &

openstack subnet create --gateway none --no-dhcp --network jslagle-master-ctlplane --subnet-range 192.168.24.0/24 jslagle-master-ctlplane &
openstack subnet create --gateway none --no-dhcp --network jslagle-master-external --subnet-range 10.0.0.0/24 jslagle-master-external &
openstack subnet create --gateway none --no-dhcp --network jslagle-master-internalapi --subnet-range 172.16.2.0/24 jslagle-master-internalapi &
openstack subnet create --gateway none --no-dhcp --network jslagle-master-storage --subnet-range 172.16.1.0/24 jslagle-master-storage &
openstack subnet create --gateway none --no-dhcp --network jslagle-master-storagemgt --subnet-range 172.16.3.0/24 jslagle-master-storagemgt &
openstack subnet create --gateway none --no-dhcp --network jslagle-master-tenant --subnet-range 172.16.0.0/24 jslagle-master-tenant &

openstack port create \
	--fixed-ip ip-address=192.168.24.100 \
	--network jslagle-master-ctlplane \
	master-control-virtual-ip &

openstack port create \
    --fixed-ip ip-address=192.168.24.2 \
    --network jslagle-master-ctlplane \
    master-local-ip &

openstack port create \
    --fixed-ip ip-address=192.168.24.3 \
    --network jslagle-master-ctlplane \
    master-admin-host &

openstack port create \
    --fixed-ip ip-address=192.168.24.4 \
    --network jslagle-master-ctlplane \
    master-public-host &

openstack port create \
    --fixed-ip ip-address=10.0.0.5 \
    --network jslagle-master-external \
    master-external-uc

master_local_ip=$(openstack port show master-local-ip -f value -c id)
master_external_uc=$(openstack port show master-external-uc -f value -c id)

openstack server create \
	--flavor ocp-master-large \
	--image CentOS-8-x86_64-GenericCloud-released-latest \
	--key-name jslagle \
	--nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f \
	--nic port-id=$master_local_ip \
	--nic port-id=$master_external_uc \
	master-uc

openstack server add floating ip master-uc 10.0.126.102

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
        --network jslagle-master-ctlplane \
        ${name}-${index}-jslagle-master-ctlplane
    master_port_id=$(openstack port show ${name}-${index}-jslagle-master-ctlplane -f value -c id)

    openstack port create \
        --fixed-ip ip-address=10.0.0.${ip} \
        --network jslagle-master-external \
        ${name}-${index}-jslagle-master-external
    external_port_id=$(openstack port show ${name}-${index}-jslagle-master-external -f value -c id)

    openstack port create \
        --fixed-ip ip-address=172.16.2.${ip} \
        --network jslagle-master-internalapi \
        ${name}-${index}-jslagle-master-internalapi
    internalapi_port_id=$(openstack port show ${name}-${index}-jslagle-master-internalapi -f value -c id)

    openstack port create \
        --fixed-ip ip-address=172.16.1.${ip} \
        --network jslagle-master-storage \
        ${name}-${index}-jslagle-master-storage
    storage_port_id=$(openstack port show ${name}-${index}-jslagle-master-storage -f value -c id)

    openstack port create \
        --fixed-ip ip-address=172.16.3.${ip} \
        --network jslagle-master-storagemgt \
        ${name}-${index}-jslagle-master-storagemgt
    storagemgt_port_id=$(openstack port show ${name}-${index}-jslagle-master-storagemgt -f value -c id)

    openstack port create \
        --fixed-ip ip-address=172.16.0.${ip} \
        --network jslagle-master-tenant \
        ${name}-${index}-jslagle-master-tenant
    tenant_port_id=$(openstack port show ${name}-${index}-jslagle-master-tenant -f value -c id)

    openstack server create \
        --flavor $flavor \
        --image CentOS-8-x86_64-GenericCloud-released-latest \
        --key-name jslagle \
        --nic port-id=$test_port_id \
        --nic port-id=$master_port_id \
        --nic port-id=$external_port_id \
        --nic port-id=$internalapi_port_id \
        --nic port-id=$storage_port_id \
        --nic port-id=$storagemgt_port_id \
        --nic port-id=$tenant_port_id \
        ${name}-${index}
}

for i in 0 1 2; do
    ip=$((10 + $i))
    create controller $ip $i ocp-master-large &
done

for i in 0 1 2; do
    ip=$((110 + $i))
    create master-compute $ip $i m1.large &
done

for i in 0 1 2; do
    openstack server delete controller-${i} &
done

for i in 0 1 2; do
    openstack port delete controller-${i}-test &
    openstack port delete controller-${i}-master &
done

for i in 66 71 81; do
    openstack port delete compute-${i}-test &
    openstack port delete compute-${i}-master &
done
for i in $(seq 0 49); do
    openstack server delete compute-${i} &
done

for i in $(seq 0 49); do
    ip=$((50 + $i))
    create compute $ip $i ci.m1.micro &
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
    openstack server rebuild controller-${i} --image CentOS-7-x86_64-GenericCloud-1808 &
done

for i in $(seq 0 49); do
    openstack server rebuild compute-${i} --image CentOS-7-x86_64-GenericCloud-1808 &
done

for i in $(seq 50 99); do
    openstack server rebuild compute-${i} &
done

for i in $(seq 0 99); do
    openstack server rebuild compute-${i} &
done
