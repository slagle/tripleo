#!/bin/bash

set -eux

openstack flavor create \
    --id auto \
    --ram 16384

