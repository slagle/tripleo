#!/bin/bash
set -eux

WORKBOOK=${WORKBOOK:-"deployment"}

source stackrc
sudo mysql mistral -e "delete from workflow_executions_v2;"
sudo mysql mistral -e "delete from action_executions_v2;"
sudo mistral-db-sync
mistral workbook-delete tripleo.${WORKBOOK}.v1 || :
mistral workbook-create ~/tripleo-common/workbooks/${WORKBOOK}.yaml
sudo systemctl try-restart openstack-mistral-*
sudo rm -rf /var/lib/mistral/*
