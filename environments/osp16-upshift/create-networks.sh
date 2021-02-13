#!/bin/bash

openstack network create --internal --disable-port-security jslagle-osp16
openstack network create --internal --disable-port-security jslagle-osp16-external
openstack network create --internal --disable-port-security jslagle-osp16-internalapi
openstack network create --internal --disable-port-security jslagle-osp16-storage
openstack network create --internal --disable-port-security jslagle-osp16-storagemgt
openstack network create --internal --disable-port-security jslagle-osp16-tenant

openstack subnet create --gateway none --no-dhcp --network jslagle-osp16 --subnet-range 192.168.24.0/24 jslagle-osp16-subnet
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-external --subnet-range 10.0.0.0/24 jslagle-osp16-external
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-internalapi --subnet-range 172.16.2.0/24 jslagle-osp16-internalapi
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storage --subnet-range 172.16.1.0/24 jslagle-osp16-storage
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storagemgt --subnet-range 172.16.3.0/24 jslagle-osp16-storagemgt
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-tenant --subnet-range 172.16.0.0/24 jslagle-osp16-tenant

openstack subnet create --gateway none --no-dhcp --network jslagle-osp16 --subnet-range 192.168.25.0/24 jslagle-osp16-dcn1-subnet &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-internalapi --subnet-range 172.17.3.0/24 jslagle-osp16-internalapi-dcn1 &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storage --subnet-range 172.17.2.0/24 jslagle-osp16-storage-dcn1 &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storagemgt --subnet-range 172.17.4.0/24 jslagle-osp16-storagemgt-dcn1 &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-tenant --subnet-range 172.17.1.0/24 jslagle-osp16-tenant-dcn1 &
wait

openstack subnet create --gateway none --no-dhcp --network jslagle-osp16 --subnet-range 192.168.26.0/24 jslagle-osp16-dcn2-subnet &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-internalapi --subnet-range 172.18.4.0/24 jslagle-osp16-internalapi-dcn2 &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storage --subnet-range 172.18.3.0/24 jslagle-osp16-storage-dcn2 &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-storagemgt --subnet-range 172.18.5.0/24 jslagle-osp16-storagemgt-dcn2 &
openstack subnet create --gateway none --no-dhcp --network jslagle-osp16-tenant --subnet-range 172.18.2.0/24 jslagle-osp16-tenant-dcn2 &
wait

openstack subnet delete jslagle-osp16-dcn1-subnet
openstack subnet delete jslagle-osp16-external-dcn1
openstack subnet delete jslagle-osp16-internalapi-dcn1
openstack subnet delete jslagle-osp16-storage-dcn1
openstack subnet delete jslagle-osp16-storagemgt-dcn1
openstack subnet delete jslagle-osp16-tenant-dcn1

openstack subnet delete jslagle-osp16-dcn2-subnet &
openstack subnet delete jslagle-osp16-external-dcn2 &
openstack subnet delete jslagle-osp16-internalapi-dcn2 &
openstack subnet delete jslagle-osp16-storage-dcn2 &
openstack subnet delete jslagle-osp16-storagemgt-dcn2 &
openstack subnet delete jslagle-osp16-tenant-dcn2 &

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

for i in 0 1 2; do openstack server remove volume osp16-dcn1-compute-$i osp16-dcn1-compute-$i & done; wait
for i in 0 1 2; do openstack volume delete  osp16-dcn1-compute-$i & done; wait
for i in 0 1 2; do openstack volume create osp16-dcn1-compute-$i --size 10 & done; wait
for i in 0 1 2; do openstack server rebuild osp16-dcn1-compute-$i --wait & done; wait
for i in 0 1 2; do openstack server add volume osp16-dcn1-compute-$i osp16-dcn1-compute-$i & done; wait


tripleo-ansible-inventory --stack dcn1 --static-yaml-inventory dcn1-inventory.yaml --ansible_ssh_user cloud-user
tripleo-config-download --stack-name dcn1 --output-dir dcn1-config-download

ssh-keygen -R 192.168.24.18
ssh-keygen -R 192.168.24.19
ssh-keygen -R 192.168.24.8
until ! nmap 192.168.24.18 192.168.24.19 192.168.24.8 -PN -p ssh 2>&1 | grep -q -E 'filtered|closed'; do echo "trying again..."; sleep 1; done
ssh-keyscan 192.168.24.18 >> /home/cloud-user/.ssh/known_hosts
ssh-keyscan 192.168.24.19 >> /home/cloud-user/.ssh/known_hosts
ssh-keyscan 192.168.24.8 >> /home/cloud-user/.ssh/known_hosts
ansible --become -i ~/dcn1-inventory.yaml -m lineinfile -a "path=/etc/resolv.conf line='nameserver 192.168.122.1' state=absent" overcloud --private-key ~/.ssh/upshift
ansible-playbook -i ~/dcn1-inventory.yaml ~/tripleo/playbooks/rhos-release.yaml --limit overcloud
ansible --become -i ~/dcn1-inventory.yaml -a "dnf -y install lvm2 http://download.devel.redhat.com/rhel-8/nightly/updates/RHEL-8/latest-RHEL-8.1.0/compose/AppStream/x86_64/os/Packages/python3-psutil-5.4.3-10.el8.x86_64.rpm" overcloud --private-key ~/.ssh/upshift

cd
tripleo-ansible-inventory --stack dcn1 --static-yaml-inventory ~/dcn1-inventory.yaml --ansible_ssh_user cloud-user
tripleo-config-download --stack-name dcn1 --output-dir ~/dcn1-config-download

cd dcn1-config-download
ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook -i ~/dcn1-inventory.yaml --become  deploy_steps_playbook.yaml -e local_ceph_ansible_fetch_directory_backup=ceph-fetch-backup

sed -i 's/latest-RHCEPH-4-RHEL-8/RHCEPH-4.0-RHEL-8-20191007.6/' /etc/yum.repos.d/rhos-release-ceph-4.repo
for i in $(seq 0 6); do ip link set dev eth$i up; done
for i in $(seq 2 6); do ifdown eth$i; ifup eth$i; done
###############################################################################
###############################################################################
###############################################################################
