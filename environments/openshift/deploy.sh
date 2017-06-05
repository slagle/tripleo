#!/bin/bash

set -eux

STACK_NAME=${STACK_NAME:-"overcloud-ceph"}
UPDATE=${UPDATE:-"0"}
HEATCLIENT=${HEATCLIENT:-"0"}
STACK_OP=${STACK_OP:-"create"}
TEMPLATES=${TEMPLATES:-"tripleo-heat-templates"}
ROLES_DATA=${ROLES_DATA:-"$(realpath roles_data.yaml)"}

ENVIRONMENTS=${ENVIRONMENTS:-""}
ENVIRONMENTS="$ENVIRONMENTS -e $TEMPLATES/overcloud-resource-registry-puppet.yaml"
ENVIRONMENTS="$ENVIRONMENTS -e $TEMPLATES/environments/puppet-pacemaker.yaml"
ENVIRONMENTS="$ENVIRONMENTS -e $TEMPLATES/environments/puppet-ceph.yaml"
ENVIRONMENTS="$ENVIRONMENTS -e environment.yaml"
ENVIRONMENTS="$ENVIRONMENTS -e passwords.yaml"

if [ "$UPDATE" = "1" ]; then
	STACK_OP="update"
fi

# sudo systemctl restart openstack-zaqar@1 openstack-mistral-*

find tripleo-heat-templates | grep 'j2\.' | sed 's/j2\.//' | xargs -rtn1 rm -f

if [ "$HEATCLIENT" = "0" ]; then

        if [ "$UPDATE" = "0" ]; then
                if mistral environment-get $STACK_NAME; then
                    mistral environment-delete $STACK_NAME
                fi

                if swift stat $STACK_NAME; then
                    swift delete $STACK_NAME
                fi

                if swift stat ${STACK_NAME}-swift-rings; then
                    swift delete ${STACK_NAME}-swift-rings
                fi
        fi

	time openstack overcloud deploy \
		--stack $STACK_NAME \
		--skip-deploy-identifier \
		--disable-validations \
		--templates $TEMPLATES \
		-r $ROLES_DATA \
		$ENVIRONMENTS
else
	pushd $TEMPLATES
	tools/process-templates.py -r $ROLES_DATA
	popd

	time openstack stack $STACK_OP \
		$STACK_NAME \
		--wait \
		--template $TEMPLATES/overcloud.yaml \
		$ENVIRONMENTS
fi
