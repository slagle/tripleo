#!/bin/bash

sudo /bin/bash -c "cat >/etc/systemd/system/add-eth1.service<<EOF
[Unit]
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'ip link add dev eth1 type dummy && ip link set dev eth1 up'

[Install]
WantedBy=multi-user.target
EOF
"

sudo systemctl daemon-reload
sudo systemctl enable add-eth1
sudo systemctl restart add-eth1

