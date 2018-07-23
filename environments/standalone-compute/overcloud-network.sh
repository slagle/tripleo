#!/bin/bash

set -eux

openstack network create --disable-port-security --external --provider-network-type flat --provider-physical-network datacentre public
