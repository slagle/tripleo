#!/bin/bash

openstack network create --internal --disable-port-security jslagle-osp16-external
openstack network create --internal --disable-port-security jslagle-osp16-internalapi
openstack network create --internal --disable-port-security jslagle-osp16-storage
openstack network create --internal --disable-port-security jslagle-osp16-storagemgt
openstack network create --internal --disable-port-security jslagle-osp16-tenant

openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-external --subnet-range 10.0.0.0/24 jslagle-osp16-external
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-internalapi --subnet-range 172.16.2.0/24 jslagle-osp16-internalapi
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storage --subnet-range 172.16.1.0/24 jslagle-osp16-storage
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storagemgt --subnet-range 172.16.3.0/24 jslagle-osp16-storagemgt
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-tenant --subnet-range 172.16.0.0/24 jslagle-osp16-tenant

openstack server add network osp16 jslagle-osp16-external
openstack server add network osp16 jslagle-osp16-internalapi
openstack server add network osp16 jslagle-osp16-storage
openstack server add network osp16 jslagle-osp16-storagemgt
openstack server add network osp16 jslagle-osp16-tenant

openstack server add network osp16-controller jslagle-osp16-external    # nic3
openstack server add network osp16-controller jslagle-osp16-internalapi # nic4
openstack server add network osp16-controller jslagle-osp16-storage     # nic5
openstack server add network osp16-controller jslagle-osp16-storagemgt  # nic6
openstack server add network osp16-controller jslagle-osp16-tenant      # nic7

openstack server add network osp16-dcn1-compute-0 jslagle-osp16-external
openstack server add network osp16-dcn1-compute-0 jslagle-osp16-internalapi
openstack server add network osp16-dcn1-compute-0 jslagle-osp16-storage
openstack server add network osp16-dcn1-compute-0 jslagle-osp16-storagemgt
openstack server add network osp16-dcn1-compute-0 jslagle-osp16-tenant

openstack server add network osp16-dcn1-compute-1 jslagle-osp16-external
openstack server add network osp16-dcn1-compute-1 jslagle-osp16-internalapi
openstack server add network osp16-dcn1-compute-1 jslagle-osp16-storage
openstack server add network osp16-dcn1-compute-1 jslagle-osp16-storagemgt
openstack server add network osp16-dcn1-compute-1 jslagle-osp16-tenant

openstack server add network osp16-dcn1-compute-2 jslagle-osp16-external
openstack server add network osp16-dcn1-compute-2 jslagle-osp16-internalapi
openstack server add network osp16-dcn1-compute-2 jslagle-osp16-storage
openstack server add network osp16-dcn1-compute-2 jslagle-osp16-storagemgt
openstack server add network osp16-dcn1-compute-2 jslagle-osp16-tenant
