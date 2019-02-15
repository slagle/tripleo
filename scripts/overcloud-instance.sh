#!/bin/bash

set -eux

if [ ! -f cirros-0.3.4-x86_64-disk.img ]; then
    curl -L -O http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
fi

if [ ! -f overcloud-key.rsa ]; then
    openstack keypair create \
        --private-key overcloud-key.rsa \
        overcloud-key
fi

chmod 0600 overcloud-key.rsa

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


openstack security group rule create --ingress --protocol icmp default || :
openstack security group rule create --egress --protocol icmp default || :
openstack security group rule create --ingress --protocol tcp --dst-port 1:1024 default || :
openstack security group rule create --egress --protocol tcp --dst-port 1:1024 default || :

openstack server create \
    --image cirros \
    --flavor tiny \
    --key-name overcloud-key \
    --network public \
    --wait \
    user
