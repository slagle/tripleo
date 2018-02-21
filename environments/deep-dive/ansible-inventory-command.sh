#!/bin/bash

set -eux

tripleo-ansible-inventory --static-yaml-inventory ~/tripleo-ansible-inventory-deep-dive.yaml --stack deep-dive
