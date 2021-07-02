#!/bin/bash

sudo /bin/bash -c "cat >/etc/systemd/system/add-eth1.service<<EOF
[Unit]
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'ip link add dev eth1 type dummy && ip link set dev eth1 up'
EOF
"

sudo systemctl daemon-reload
sudo systemctl restart add-eth1

