#!/bin/bash

set -eux

jq '.["nodes"][] | "sudo vbmc add --username " + ."pm_user" + " --password " + ."pm_password" + " --port " + ."pm_port" + " --address " + ."pm_addr" + " --libvirt-uri \"qemu+ssh://root@" + "192.168.23.1" + "/system?&keyfile=/root/.ssh/id_rsa_virt_power&no_verify=1&no_tty=1\" " + (."name"|sub("-";"_"))' $1 -r

set +x
for node in $(sudo vbmc list | grep down | awk '{print $2}'); do
  echo sudo vbmc start $node
done
