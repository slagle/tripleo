#!/bin/bash

ansible-playbook -i tripleo/environments/master-upshift/inventory.yaml tripleo/environments/master-upshift/bootstrap.yaml
