#!/bin/bash

set -eux

BASE_IMAGE=${BASE_IMAGE:-"rhel-guest-image-7.4-191.x86_64.qcow2"}
NEW_IMAGES=${NEW_IMAGES:-"controller-0 compute-0"}
KEY=${KEY:-"/home/stack/.ssh/id_rsa.pub"}

for image in $NEW_IMAGES; do
  file=${image}.qcow2
  if [ -f $file ]; then
    echo "Won't overwrite existing image!"
    exit 1
  fi

  qemu-img create -f qcow2 $file 80G

  virt-resize --expand /dev/sda1 $BASE_IMAGE $file

  virt-customize -a $file \
    --root-password password:root \
    --hostname $image.redhat.local \
    --run-command "yum localinstall -y http://download.lab.bos.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/rhos-release-latest.noarch.rpm" \
    --run-command "useradd -G wheel stack" \
    --run-command "sed -i 's/# %wheel/%wheel/g' /etc/sudoers" \
    --run-command "systemctl disable cloud-init cloud-config cloud-final cloud-init-local" \
    --ssh-inject root:string:"$(cat $KEY)" \
    --ssh-inject stack:string:"$(cat $KEY)" \
    --password stack:password:stack \
    --selinux-relabel

    # --run-command "yum -y install git" \
    # --run-command "git clone https://github.com/slagle/tripleo /root/tripleo" \
    # --run-command "/root/tripleo/scripts/add-to-bashrc" \
    # --run-command "rhos-release 12 -p 2017-10-30.1" \
    # --run-command "yum -y install git python-heat-agent*" \
done

