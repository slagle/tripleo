#!/bin/bash

set -ux

docker ps -q -a | xargs -t docker stop
docker ps -q -a | xargs -t docker rm -f

rm -rf /var/lib/mysql/* /var/lib/rabbitmq/* /var/lib/config-data/* /var/lib/heat-config/* /var/log/heat* /var/lib/docker-puppet /var/lib/docker-config-scripts /var/lib/ironic/* /var/lib/ironic-inspector/*
