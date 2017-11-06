#!/bin/bash

set -eux

SSH_KEY=${SSH_KEY:-"$HOME/.ssh/config-download"}

if [ ! -f "$SSH_KEY" ]; then
    openstack workflow env show ssh_keys -c Variables -f value | jq .private_key -r > $SSH_KEY
    chmod 0600 $SSH_KEY
fi

execution_id=$(ls -tr /var/lib/mistral | head -n 1)

pushd /var/lib/mistral/$execution_id
sudo ansible-playbook --inventory tripleo-ansible-inventory --private-key $SSH_KEY --user tripleo-admin deploy_steps_playbook.yaml
popd
