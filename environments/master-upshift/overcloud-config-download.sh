#!/bin/bash

set -eux

tripleo-config-download \
    --stack-name $STACK_NAME \
    --output-dir ~/centos/overcloud-config-download
