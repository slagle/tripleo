#!/bin/bash

set -eux

vbmc add --address 172.16.222.1 --port 623 dcn2-compute-0
vbmc add --address 172.16.222.1 --port 624 dcn2-compute-1
vbmc add --address 172.16.222.1 --port 625 dcn2-compute-2
vbmc add --address 172.16.222.1 --port 626 dcn2-controller-0
vbmc add --address 172.16.222.1 --port 627 dcn2-controller-1
vbmc add --address 172.16.222.1 --port 628 dcn2-controller-2

vbmc start dcn2-compute-0
vbmc start dcn2-compute-1
vbmc start dcn2-compute-2
vbmc start dcn2-controller-0
vbmc start dcn2-controller-1
vbmc start dcn2-controller-2
