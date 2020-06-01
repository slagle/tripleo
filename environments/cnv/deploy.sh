#!/bin/bash

sudo openstack tripleo deploy \
    --templates /home/cloud-user/tripleo-heat-templates \
    --roles-file /home/cloud-user/tripleo/environments/cnv/roles-data.yaml \
    -n /home/cloud-user/tripleo-heat-templates/network_data.yaml \
    -e /home/cloud-user/tripleo-heat-templates/overcloud-resource-registry-puppet.yaml \
    -e /home/cloud-user/tripleo-heat-templates/environments/deployed-server-environment.yaml \
    -e /home/cloud-user/tripleo/environments/passwords.yaml \
    -e /home/cloud-user/tripleo/environments/stack-action-create.yaml \
    -e /home/cloud-user/tripleo/environments/osp16-docker-ha.yaml \
    -e /home/cloud-user/tripleo/environments/deploy-identifier.yaml \
    -e /home/cloud-user/tripleo/environments/cnv/role-counts.yaml \
    -e /home/cloud-user/tripleo/environments/cnv/hostnamemap.yaml \
    -e /home/cloud-user/tripleo/environments/cnv/network-environment.yaml \
    -e /home/cloud-user/tripleo/environments/cnv/deployed-server-port-map.yaml \
    -e /home/cloud-user/tripleo/environments/cnv/root-stack-name.yaml \
    -e /home/cloud-user/tripleo/environments/containers-rhosp16-prepare-parameter.yaml \
    -e /home/cloud-user/tripleo/environments/containers-rhosp16-latest.yaml \
    -e /home/cloud-user/tripleo/environments/glance-backend-file.yaml \
    --output-dir /home/cloud-user/tripleo-deploy \
    --output-only \
    --standalone \
    --local-ip 192.168.24.6
