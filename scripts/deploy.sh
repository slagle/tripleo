#!/bin/bash

set -eux

STACK_NAME=${STACK_NAME:-"overcloud"}
UPDATE=${UPDATE:-"0"}
CLEANUP=${CLEANUP:-"0"}
HEATCLIENT=${HEATCLIENT:-"0"}
STACK_OP=${STACK_OP:-"create"}
EXISTING=${EXISTING:-"--existing"}
TEMPLATES=${TEMPLATES:-"tripleo-heat-templates"}
ROLES_DATA=${ROLES_DATA:-"$(realpath $TEMPLATES/roles_data.yaml)"}
COMMON_ENVIRONMENTS=${COMMON_ENVIRONMENTS:-"1"}
ENVIRONMENTS=${ENVIRONMENTS:-""}

if [ "$COMMON_ENVIRONMENTS" = "1" ]; then
    ENVIRONMENTS="-e $TEMPLATES/environments/puppet-pacemaker.yaml $ENVIRONMENTS"
    ENVIRONMENTS="-e $TEMPLATES/overcloud-resource-registry-puppet.yaml $ENVIRONMENTS"
fi

if [ "$UPDATE" = "1" ]; then
        STACK_OP="update"
    if [ "$EXISTING" = "0" ]; then
        EXISTING=""
    fi
fi

find $TEMPLATES | grep 'j2\.' | sed 's/j2\.//' | xargs -rtn1 rm -f

if [ "$HEATCLIENT" = "0" ]; then

        if [ "$CLEANUP" = "1" -a "$UPDATE" = "0" ]; then
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
                --templates $TEMPLATES \
                -r $ROLES_DATA \
                $ENVIRONMENTS \
        $@
else
        pushd $TEMPLATES
        tools/process-templates.py -r $ROLES_DATA
        popd

        time openstack stack $STACK_OP \
            $STACK_NAME \
            $EXISTING \
            --wait \
            --template $TEMPLATES/overcloud.yaml \
            $ENVIRONMENTS \
            $@

fi

