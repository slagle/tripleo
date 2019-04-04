#!/bin/bash

set -eux

infrared virsh \
  -o provision-tripleo-05.yml \
  --topology-nodes undercloud:1,controller:3,compute:3 \
  --topology-network 3_nets -e net=220 -e data_net=220 \
  --prefix core \
  --host-address $(hostname) \
  --host-memory-overcommit False \
  --host-key /root/.ssh/id_rsa \
  --image-url https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 \
  --collect-ansible-facts False
