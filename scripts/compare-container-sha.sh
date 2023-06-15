#!/bin/bash

set -eu

LOGIN=${LOGIN:-"jslagle@redhat.com"}
PASSWORD=${PASSWORD:-""}
TAG=${TAG:-"16.2.2"}

if [ -z "${PASSWORD}" ]; then
    echo "\${PASSWORD} must be set"
    exit 1
fi

# Get bearer token
TOKEN=$(curl -s -k -L --user ${LOGIN}:${PASSWORD} https://registry.redhat.io/auth/realms/rhcc/protocol/redhat-docker-v2/auth -G -d scope='repository:rhosp-rhel8/openstack-nova-api:pull' -d service=docker-registry | jq -r .token)

# Get sha256 of first manifest
SHA256=$(curl -s -k -L  https://registry.redhat.io/v2/rhosp-rhel8/openstack-nova-api/manifests/${TAG} --user jslagle@redhat.com --oauth2-bearer "${TOKEN}" -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" | jq -r .manifests[0].digest | cut -d: -f2)

# Recalculate sha256 after jq format with indent=3
NEW_SHA256=$(curl -s -k -L https://registry.redhat.io/v2/rhosp-rhel8/openstack-nova-api/manifests/sha256:${SHA256} --user jslagle@redhat.com --oauth2-bearer "${TOKEN}" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" | jq -j --indent 3 .| sha256sum | awk '{print $1}')

echo "Fetched SHA256: ${SHA256}"
echo "New SHA256 after JSON reformat: ${NEW_SHA256}"

if [ "${SHA256}" != "${NEW_SHA256}" ]; then
    echo "SHA256 not equal"
else
    echo "SHA256 equal"
fi

