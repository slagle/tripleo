#!/bin/bash

set -eux

infrared virsh \
  -o provision-tripleo-06.yml \
  --topology-nodes compute:3 \
  --topology-network 3_nets -e net=222 -e data_net=222 \
  --prefix dcn2 \
  --host-address tripleo-06.tripleo.lab.eng.bos.redhat.com \
  --host-memory-overcommit False \
  --host-key /root/.ssh/id_rsa \
  --image-url https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 \
  --collect-ansible-facts False
