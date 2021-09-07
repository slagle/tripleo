#!/bin/bash

set -eux

openstack service create --name neutron network
openstack endpoint create network admin http://192.168.122.56:9696 --region regionOne
openstack endpoint create network public https://192.168.122.57:13696 --region regionOne
openstack endpoint create network internal http://192.168.122.56:9696 --region regionOne
