#!/bin/bash

set -eux

STACK_NAME=${STACK_NAME:-"overcloud"}
UPDATE=${UPDATE:-"0"}
CLEANUP=${CLEANUP:-"0"}
HEATCLIENT=${HEATCLIENT:-"0"}
STACK_OP=${STACK_OP:-"create"}
EXISTING=${EXISTING:-"--existing"}
TEMPLATES=${TEMPLATES:-"tripleo-heat-templates"}
ROLES_DATA=${ROLES_DATA:-"$TEMPLATES/roles_data.yaml"}
ROLES_DATA=$(realpath $ROLES_DATA)
NETWORK_DATA=${NETWORK_DATA:-"$TEMPLATES/network_data.yaml"}
NETWORK_DATA=$(realpath $NETWORK_DATA)
COMMON_ENVIRONMENTS=${COMMON_ENVIRONMENTS:-"1"}
ENVIRONMENTS=${ENVIRONMENTS:-""}
ARGS=${ARGS:-""}

source ~/stackrc

if [ "$COMMON_ENVIRONMENTS" = "1" ]; then
    # ENVIRONMENTS="-e $TEMPLATES/environments/puppet-pacemaker.yaml $ENVIRONMENTS"
    ENVIRONMENTS="\
        -e $TEMPLATES/overcloud-resource-registry-puppet.yaml \
        -e $TEMPLATES/environments/docker-ha.yaml \
        $ENVIRONMENTS"
fi

if [ "$UPDATE" = "1" ]; then
    STACK_OP="update"
    EXISTING="--existing"
fi

if [ "$STACK_OP" = "create" -a "$HEATCLIENT" = "1" ]; then
    EXISTING=""
    ENVIRONMENTS="\
        -e $HOME/tripleo/environments/stack-action-create.yaml \
        $ENVIRONMENTS"
else
    ENVIRONMENTS="\
        -e $HOME/tripleo/environments/stack-action-update.yaml \
        $ENVIRONMENTS"
fi

pushd $TEMPLATES
tools/process-templates.py -c -r $ROLES_DATA -n $NETWORK_DATA
find $TEMPLATES | grep 'j2\.' | sed 's/j2\.//' | xargs -rtn1 rm -f
tools/process-templates.py -r $ROLES_DATA -n $NETWORK_DATA
popd

if [ "$HEATCLIENT" = "0" ]; then

        if [ "$CLEANUP" = "1" -a "$UPDATE" = "0" ]; then
                if mistral environment-get $STACK_NAME; then
                    mistral environment-delete $STACK_NAME
                fi

                if openstack container show $STACK_NAME; then
                    openstack container delete -r $STACK_NAME
                fi

                if openstack container show ${STACK_NAME}-swift-rings; then
                    openstack container delete -r ${STACK_NAME}-swift-rings
                fi
        fi

        echo "Starting deploy"
        date | unbuffer -p tee -a deploy.log
        time openstack overcloud deploy \
                --verbose \
                --stack $STACK_NAME \
                --templates $TEMPLATES \
                -r $ROLES_DATA \
                -n $NETWORK_DATA \
                $ARGS \
                $ENVIRONMENTS \
                $@ 2>&1
        date | unbuffer -p tee -a deploy.log
        echo "Ending deploy"
else

        echo "Starting deploy"
        date | unbuffer -p tee -a deploy.log
        time unbuffer openstack stack $STACK_OP \
            $STACK_NAME \
            $EXISTING \
            --wait \
            --template $TEMPLATES/overcloud.yaml \
            $ENVIRONMENTS \
            $@ 2>&1 | unbuffer -p tee -a deploy.log
        date | unbuffer -p tee -a deploy.log
        echo "Ending deploy"
            # $@ 2>&1 | while read line; do date | tr "\n" " "; echo $line; done | unbuffer -p tee -a deploy.log

fi

