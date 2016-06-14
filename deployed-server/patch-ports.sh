#!/bin/bash

set -eux

BRIDGE1=$1
BRIDGE2=$2

ovs-vsctl \
  -- --may-exist add-port $BRIDGE1 ${BRIDGE2}-patch \
     -- set interface ${BRIDGE2}-patch type=patch options:peer=${BRIDGE1}-patch \
  -- --may-exist add-port $BRIDGE2 ${BRIDGE1}-patch \
     -- set interface ${BRIDGE1}-patch type=patch options:peer=${BRIDGE2}-patch

