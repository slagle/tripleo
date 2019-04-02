#!/bin/bash

set -eux

if [ ! -f cirros-0.3.4-x86_64-disk.img ]; then
    curl -L -O http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
fi

if [ ! -f overcloud-key.rsa ]; then
    ssh-keygen -f overcloud-key.rsa
    chmod 0600 overcloud-key.rsa
fi

if ! openstack keypair show overcloud-key; then
    openstack keypair create \
        --private-key overcloud-key.rsa \
        overcloud-key
fi

if ! openstack flavor show tiny; then
    openstack flavor create \
        --ram 256 \
        --disk 1 \
        --vcpus 1 \
        tiny
fi

if ! openstack image show cirros; then
    openstack image create \
        --container-format bare \
        --disk-format qcow2 \
        --file cirros-0.3.4-x86_64-disk.img \
        cirros
fi

sec_group_id=$(openstack security group list --project admin -c ID -f value)

openstack security group rule create --ingress --protocol icmp $sec_group_id || :
openstack security group rule create --egress --protocol icmp $sec_group_id || :
openstack security group rule create --ingress --protocol tcp --dst-port 1:1024 $sec_group_id || :
openstack security group rule create --egress --protocol tcp --dst-port 1:1024 $sec_group_id || :

openstack server create \
    --image cirros \
    --flavor tiny \
    --key-name overcloud-key \
    --network private \
    --wait \
    user-$(date +%s)
