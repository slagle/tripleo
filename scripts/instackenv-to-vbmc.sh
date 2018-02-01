#!/bin/bash

set -eux

jq '.["nodes"][] | "vbmc add --username " + ."pm_user" + " --password " + ."pm_password" + " --port " + ."pm_port" + " --address " + ."pm_addr" + " --libvirt-uri qemu:///session " + (."name"|sub("-";"_"))' instackenv.json -r
:xa
ch

echo $(vbmc list | grep down | awk '{print $2}' | xargs -n 1 echo vbmc start)
