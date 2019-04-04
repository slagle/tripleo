#!/bin/bash

set -eux

vbmc add --address 172.16.221.1 --port 623 dcn1-compute-0
vbmc add --address 172.16.221.1 --port 624 dcn1-compute-1
vbmc add --address 172.16.221.1 --port 625 dcn1-compute-2
vbmc add --address 172.16.221.1 --port 626 dcn1-controller-0
vbmc add --address 172.16.221.1 --port 627 dcn1-controller-1
vbmc add --address 172.16.221.1 --port 628 dcn1-controller-2

vbmc start dcn1-compute-0
vbmc start dcn1-compute-1
vbmc start dcn1-compute-2
vbmc start dcn1-controller-0
vbmc start dcn1-controller-1
vbmc start dcn1-controller-2
