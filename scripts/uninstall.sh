#!/bin/bash

IMAGES=${IMAGES:-0}

echo "Tearing down TripleO environment"
if type pcs &> /dev/null; then
    sudo pcs cluster destroy
fi
if type podman &> /dev/null; then
    echo "Removing podman containers and images (takes times...)"
    sudo podman rm -af
	if [ "$IMAGES" = "1" ]; then
    	sudo podman rmi -af
	fi
fi
sudo rm -rf \
    /var/lib/tripleo-config \
    /var/lib/config-data /var/lib/container-config-scripts \
    /var/lib/container-puppet \
    /var/lib/heat-config \
    /var/lib/image-serve \
    /var/lib/containers \
    /etc/systemd/system/tripleo* \
    /var/lib/mysql/*
sudo systemctl daemon-reload
