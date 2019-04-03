#!/bin/bash

set -ux

openstack subnet set --dns-nameserver 10.11.5.19 ctlplane-subnet
