#!/bin/bash

set -eux

STACK=${STACK:-"overcloud"}
ROLES=${ROLES:-"ComputeDeployedServer NetworkerDeployedServer"}

for role in $ROLES; do
    rg=$(openstack stack resource list $STACK --filter name=$role -f value -c physical_resource_id)
    stacks=$(openstack stack resource list -n5 $rg --filter name=deployed-server -c stack_name -f value)

    for stack in $stacks; do
        echo "# $stack"
        metadata=$(openstack stack resource metadata $stack deployed-server -f json)
        parts=$(echo $metadata | jq '.["os-collect-config"]["request"]["metadata_url"]' | cut -d '/' -f 6,7 | cut -d '?' -f 1)
	    container=$(echo $parts | cut -d '/' -f1)
        object=$(echo $parts | cut -d '/' -f2)
		echo "#  container: $container"
 		echo "#  object: $object"
        echo "echo '{}' > $object"
        echo openstack container create $container
        echo openstack object create $container $object
        echo rm -f $object
        echo
    done
done
