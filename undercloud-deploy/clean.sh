#!/bin/bash

set -ux

docker ps -q -a | xargs -tn1 docker stop
docker ps -q -a | xargs -tn1 docker rm -f

rm -rf /var/lib/mysql/* /var/lib/rabbitmq/* /var/lib/config-data/rabbitmq/etc/rabbitmq/*
rm -rf /var/lib/ironic/* /var/lib/ironic-inspector/*
