#!/bin/bash

ansible-playbook --forks 20 -i tripleo/environments/master-upshift/inventory.yaml tripleo/environments/master-upshift/bootstrap.yaml
