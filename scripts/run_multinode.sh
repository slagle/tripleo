#!/bin/bash

set -eux

export TOCI=${TOCI:-0}
export DO_MULTINODE_SETUP=${DO_MULTINODE_SETUP:-1}
export DO_DEPLOY=${DO_DEPLOY:-1}
export SETUP_NODEPOOL_FILES=${SETUP_NODEPOOL_FILES:-1}
export DO_BOOTSTRAP=${DO_BOOTSTRAP:-1}
export TRIPLEO_ROOT=${TRIPLEO_ROOT:-/opt/stack/new}
export PRIMARY_NODE_IP=${PRIMARY_NODE_IP:-""}
export SUB_NODE_IPS=${SUB_NODE_IPS:-""}
export CLONE_REPOS=${CLONE_REPOS:-"0"}
export NODEPOOL_REGION=${NODEPOOL_REGION:-"nodepool_region"}
export NODEPOOL_CLOUD=${NODEPOOL_CLOUD:-"nodepool_cloud"}
export http_proxy=${http_proxy:-""}
export SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
export OVERCLOUD_DEPLOY_ARGS=${OVERCLOUD_DEPLOY_ARGS:-""}
export OVERCLOUD_SSH_USER=$(whoami)
export TOCI_JOBTYPE="gate-multinode"
export DEVSTACK_GATE_TIMEOUT=150
export WORKSPACE=$TRIPLEO_ROOT/workspace
export ZUUL_BRANCH=master
export OVERRIDE_ZUUL_BRANCH=master

sudo mkdir -p $TRIPLEO_ROOT
sudo mkdir -p $WORKSPACE
sudo chown -R $(whoami): $TRIPLEO_ROOT

rm -f $TRIPLEO_ROOT/tripleo-ci/deploy.env

# setup_nodepool_files creates the files on each node as they would have been
# created by nodepool.
function setup_nodepool_files {
    sudo mkdir -p /etc/nodepool
    sudo chown -R $(whoami): /etc/nodepool

    if [ ! -f /etc/nodepool/id_rsa ]; then
        ssh-keygen -N "" -t rsa -f /etc/nodepool/id_rsa
    fi

    echo $PRIMARY_NODE_IP > /etc/nodepool/node
    echo $PRIMARY_NODE_IP > /etc/nodepool/primary_node
    echo $PRIMARY_NODE_IP > /etc/nodepool/primary_node_private

    echo -n > /etc/nodepool/sub_nodes
    echo -n > /etc/nodepool/sub_nodes_private
    for sub_node_ip in $SUB_NODE_IPS; do
        echo $sub_node_ip >> /etc/nodepool/sub_nodes
        echo $sub_node_ip >> /etc/nodepool/sub_nodes_private

        ssh $SSH_OPTIONS -tt $sub_node_ip sudo mkdir -p $TRIPLEO_ROOT
        ssh $SSH_OPTIONS -tt $sub_node_ip sudo chown -R $(whoami): $TRIPLEO_ROOT
        rsync -e "ssh $SSH_OPTIONS" -avhP $TRIPLEO_ROOT $sub_node_ip:$TRIPLEO_ROOT/..
        rsync -e "ssh $SSH_OPTIONS" -avhP /etc/nodepool $sub_node_ip:
        ssh $SSH_OPTIONS -tt $sub_node_ip sudo cp -r nodepool /etc
        ssh $SSH_OPTIONS $sub_node_ip \
            "/bin/bash -c 'cat /etc/nodepool/id_rsa.pub >> ~/.ssh/authorized_keys'"
    done

    echo "NODEPOOL_REGION=$NODEPOOL_REGION" > /etc/nodepool/provider
    echo "NODEPOOL_CLOUD=$NODEPOOL_CLOUD" >> /etc/nodepool/provider
}

if [ -z "$PRIMARY_NODE_IP" ]; then
    echo \$PRIMARY_NODE_IP must be set
    exit 1
fi

if [ -z "$SUB_NODE_IPS" ]; then
    echo \$SUB_NODE_IPS must be set
    exit 1
fi

if ! rpm -q git; then
    sudo yum -y install git
    git config --global user.email "tripleo-ci@example.com"
    git config --global user.name "tripleo-ci"
fi

if [ ! -f $TRIPLEO_ROOT/new ]; then
    sudo ln -s -f $TRIPLEO_ROOT $TRIPLEO_ROOT/new
fi

$TRIPLEO_ROOT/tripleo-ci/scripts/tripleo.sh --repo-setup

if [ "$SETUP_NODEPOOL_FILES" = "1" ]; then
    setup_nodepool_files
fi

if [ "$DO_MULTINODE_SETUP" = "1" ]; then
    sudo ip a del 192.0.2.2/24 dev br-ex || :
    $TRIPLEO_ROOT/tripleo-ci/scripts/tripleo.sh --multinode
fi

if [ "$DO_BOOTSTRAP" = "1" ]; then
    $TRIPLEO_ROOT/tripleo-ci/scripts/tripleo.sh --bootstrap-subnodes
fi

if [ "$DO_DEPLOY" = "1" ]; then
    if [ "$TOCI" = "1" ]; then
        sudo ip a del 192.0.2.2/24 dev br-ex || :
        $TRIPLEO_ROOT/tripleo-ci/toci_gate_test.sh
    else
        source stackrc
        OVERCLOUD_DEPLOY_ARGS="$OVERCLOUD_DEPLOY_ARGS --templates /usr/share/openstack-tripleo-heat-templates -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/deployed-server-environment.yaml -e $TRIPLEO_ROOT/tripleo-ci/test-environments/multinode.yaml --control-scale 3 --compute-scale 0 --overcloud-ssh-user $(whoami) --ntp-server 0.fedora.pool.ntp.org --validation-errors-nonfatal"
        openstack overcloud deploy $OVERCLOUD_DEPLOY_ARGS
    fi
fi
