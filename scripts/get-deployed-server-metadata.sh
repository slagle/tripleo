#!/bin/bash

set -eux

stacks=$(openstack stack resource list -n7 cisco --filter name=deployed-server -c stack_name -f value)

for stack in $stacks; do
    echo $stack
	openstack stack resource metadata $stack deployed-server -f json | jq '.["os-collect-config"]'
done
