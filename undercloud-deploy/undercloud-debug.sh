#!/bin/bash

set -eux

sudo docker commit undercloud-deploy undercloud-debug
sudo docker run -it  --user=root --net=host --privileged --volumes-from undercloud-volumes --entrypoint="/bin/bash" -v /var/run/docker.sock:/var/run/docker.sock undercloud-debug
