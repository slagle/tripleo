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

for n in external internalapi storage storagemgt tenant; do
    openstack server add network osp16 jslagle-osp16-$n &
done

for n in external internalapi storage storagemgt tenant; do
    openstack server add network osp16-controller jslagle-osp16-$n &
done

###############################################################################
## DCN1
###############################################################################
for i in 0 1 2; do
    for n in external internalapi storage storagemgt tenant; do
        openstack server remove network osp16-dcn1-compute-$i jslagle-osp16-$n &
    done
done
wait

for i in 0 1 2; do
    for n in external internalapi storage storagemgt tenant; do
        openstack server add network osp16-dcn1-compute-$i jslagle-osp16-$n
    done
done

for i in 0 1 2; do openstack server remove volume osp16-dcn1-compute-$i osp16-dcn1-compute-$i & done
wait
for i in 0 1 2; do openstack server rebuild osp16-dcn1-compute-$i & done
for i in 0 1 2; do openstack volume delete  osp16-dcn1-compute-$i & done
wait
for i in 0 1 2; do openstack volume create osp16-dcn1-compute-$i --size 10 & done
wait
for i in 0 1 2; do openstack server add volume osp16-dcn1-compute-$i osp16-dcn1-compute-$i & done

ssh-keygen -R 192.168.24.18
ssh-keygen -R 192.168.24.19
ssh-keygen -R 192.168.24.8

tripleo-ansible-inventory --stack dcn1 --static-yaml-inventory dcn1-inventory.yaml --ansible_ssh_user cloud-user
tripleo-config-download --stack-name dcn1 --output-dir dcn1-config-download

ansible-playbook -i ~/dcn1-inventory.yaml ~/tripleo/playbooks/rhos-release.yaml --limit overcloud
ansible --become -i ~/dcn1-inventory.yaml -a "dnf -y install lvm2" overcloud --private-key ~/.ssh/upshift
ansible --become -i ~/dcn1-inventory.yaml -m lineinfile -a "path=/etc/resolv.conf line='nameserver 192.168.122.1' state=absent" overcloud --private-key ~/.ssh/upshift

cd dcn1-config-download; ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook -i ~/dcn1-inventory.yaml --become  deploy_steps_playbook.yaml

ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook -i ~/dcn1-inventory.yaml --become  deploy_steps_playbook.yaml --start-at-task "External deployment step 2" -e @global_vars.yam l -e gather_facts=true -e local_ceph_ansible_fetch_directory_backup=ceph-fetch-backup

for i in $(seq 0 6); do ip link set dev eth$i up; done
for i in $(seq 2 6); do ifdown eth$i; ifup eth$i; done

###############################################################################
###############################################################################
###############################################################################
