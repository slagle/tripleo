#!/bin/bash

set -eux

vbmc add --address 172.16.220.1 --port 623 core-compute-0
vbmc add --address 172.16.220.1 --port 624 core-compute-1
vbmc add --address 172.16.220.1 --port 625 core-compute-2
vbmc add --address 172.16.220.1 --port 626 core-controller-0
vbmc add --address 172.16.220.1 --port 627 core-controller-1
vbmc add --address 172.16.220.1 --port 628 core-controller-2

vbmc start core-compute-0
vbmc start core-compute-1
vbmc start core-compute-2
vbmc start core-controller-0
vbmc start core-controller-1
vbmc start core-controller-2
