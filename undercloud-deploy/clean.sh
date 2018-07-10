#!/bin/bash

set -ux

sudo docker ps -q -a | sudo xargs -t docker stop
sudo docker ps -q -a | sudo xargs -t docker rm -f

sudo rm -rf /var/lib/mysql/* /var/lib/rabbitmq/* /var/lib/config-data/* /var/lib/heat-config/* /var/log/heat* /var/lib/docker-puppet /var/lib/docker-config-scripts /var/lib/ironic/* /var/lib/ironic-inspector/*
