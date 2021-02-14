export IMAGE="RHEL-8.2.1-x86_64-latest"
export FLAVOR="ocp-master-large"

function create-osp16 {
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.1 --disable-port-security osp16-local-ip
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.2 --disable-port-security osp16-public-host
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.3 --disable-port-security osp16-admin-host
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.5 --disable-port-security osp16-external

	openstack server create --flavor $FLAVOR --network jslagle-test --image $IMAGE --key-name jslagle osp16
	openstack server add port osp16 osp16-local-ip
	openstack server add port osp16 osp16-external
	openstack server add floating ip osp16 10.0.126.36
}

function rebuild-controller {
	openstack server rebuild --image $IMAGE osp16-controller &
}

function controller-create {
	set -x
	openstack server create --flavor $FLAVOR --nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f,v4-fixed-ip=192.168.1.22 --image $IMAGE --key-name jslagle osp16-controller


	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.10 --disable-port-security osp16-controller &
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt,ip-address=172.16.3.10 --disable-port-security osp16-controller-storagemgt &
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant,ip-address=172.16.0.10 --disable-port-security osp16-controller-tenant &
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi,ip-address=172.16.2.10 --disable-port-security osp16-controller-internalapi &
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage,ip-address=172.16.1.10 --disable-port-security osp16-controller-storage &
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.10 --disable-port-security osp16-controller-external &
	wait

	while openstack server list | grep osp16-controller | grep BUILD; do sleep 3; done
	openstack server add port osp16-controller osp16-controller
	openstack server add port osp16-controller osp16-controller-storagemgt
	openstack server add port osp16-controller osp16-controller-tenant
	openstack server add port osp16-controller osp16-controller-internalapi
	openstack server add port osp16-controller osp16-controller-storage
	openstack server add port osp16-controller osp16-controller-external
	set +x
}

function controller-delete {
	set -x
	openstack server delete osp16-controller
	openstack port delete osp16-controller &
	openstack port delete osp16-controller-storagemgt &
	openstack port delete osp16-controller-tenant &
	openstack port delete osp16-controller-internalapi &
	openstack port delete osp16-controller-storage &
	openstack port delete osp16-controller-external &
	set +x
	wait
}

function create-vips {
	# VIPs
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.100 --disable-port-security osp16-control-vip
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.101 --disable-port-security osp16-ovndbs-vip
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt,ip-address=172.16.3.100 --disable-port-security osp16-storagemgt-vip
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant,ip-address=172.16.0.100 --disable-port-security osp16-tenant-vip
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi,ip-address=172.16.2.100 --disable-port-security osp16-internalapi-vip
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage,ip-address=172.16.1.100 --disable-port-security osp16-storage-vip
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.100 --disable-port-security osp16-external-vip
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.119 --disable-port-security osp16-public-vip
}

function dcn1-create {
	set -x

	openstack server create --flavor m1.large --nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f,v4-fixed-ip=192.168.1.78 --image $IMAGE --key-name jslagle osp16-dcn1-0 &
	openstack server create --flavor m1.large --nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f,v4-fixed-ip=192.168.1.79 --image $IMAGE --key-name jslagle osp16-dcn1-1 &
	openstack server create --flavor m1.large --nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f,v4-fixed-ip=192.168.1.42 --image $IMAGE --key-name jslagle osp16-dcn1-2 &
	wait

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-dcn1-subnet,ip-address=192.168.25.20 --disable-port-security osp16-dcn1-0 &
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn1,ip-address=172.17.3.20 --disable-port-security osp16-dcn1-0-storagemgt &
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn1,ip-address=172.17.0.20 --disable-port-security osp16-dcn1-0-tenant &
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn1,ip-address=172.17.2.20 --disable-port-security osp16-dcn1-0-internalapi &
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn1,ip-address=172.17.1.20 --disable-port-security osp16-dcn1-0-storage &
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.20 --disable-port-security osp16-dcn1-0-external &

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-dcn1-subnet,ip-address=192.168.25.21 --disable-port-security osp16-dcn1-1 &
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn1,ip-address=172.17.3.21 --disable-port-security osp16-dcn1-1-storagemgt &
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn1,ip-address=172.17.0.21 --disable-port-security osp16-dcn1-1-tenant &
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn1,ip-address=172.17.2.21 --disable-port-security osp16-dcn1-1-internalapi &
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn1,ip-address=172.17.1.21 --disable-port-security osp16-dcn1-1-storage &
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.21 --disable-port-security osp16-dcn1-1-external &

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-dcn1-subnet,ip-address=192.168.25.22 --disable-port-security osp16-dcn1-2 &
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn1,ip-address=172.17.3.22 --disable-port-security osp16-dcn1-2-storagemgt &
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn1,ip-address=172.17.0.22 --disable-port-security osp16-dcn1-2-tenant &
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn1,ip-address=172.17.2.22 --disable-port-security osp16-dcn1-2-internalapi &
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn1,ip-address=172.17.1.22 --disable-port-security osp16-dcn1-2-storage &
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.22 --disable-port-security osp16-dcn1-2-external &
	wait

	while openstack server list | grep osp16-dcn1 | grep BUILD; do sleep 3; done

	openstack server add port osp16-dcn1-0 osp16-dcn1-0
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-storagemgt
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-tenant
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-internalapi
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-storage
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-external

	openstack server add port osp16-dcn1-1 osp16-dcn1-1
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-storagemgt
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-tenant
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-internalapi
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-storage
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-external

	openstack server add port osp16-dcn1-2 osp16-dcn1-2
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-storagemgt
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-tenant
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-internalapi
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-storage
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-external

	set +x
}

function dcn1-delete {
	set -x

	for i in 0 1 2; do openstack server remove volume osp16-dcn1-$i osp16-dcn1-1-$i & done; wait
	for i in 0 1 2; do openstack volume delete  osp16-dcn1-1-$i & done; wait

	for i in 0 1 2; do openstack server delete osp16-dcn1-$i & done; wait

	openstack port delete osp16-dcn1-0 &
	openstack port delete osp16-dcn1-0-storagemgt &
	openstack port delete osp16-dcn1-0-tenant &
	openstack port delete osp16-dcn1-0-internalapi &
	openstack port delete osp16-dcn1-0-storage &
	openstack port delete osp16-dcn1-0-external &
	openstack port delete osp16-dcn1-1 &
	openstack port delete osp16-dcn1-1-storagemgt &
	openstack port delete osp16-dcn1-1-tenant &
	openstack port delete osp16-dcn1-1-internalapi &
	openstack port delete osp16-dcn1-1-storage &
	openstack port delete osp16-dcn1-1-external &
	openstack port delete osp16-dcn1-2 &
	openstack port delete osp16-dcn1-2-storagemgt &
	openstack port delete osp16-dcn1-2-tenant &
	openstack port delete osp16-dcn1-2-internalapi &
	openstack port delete osp16-dcn1-2-storage &
	openstack port delete osp16-dcn1-2-external &
	wait
	set +x
}

function dcn1-volumes {
	for i in 0 1 2; do openstack server remove volume osp16-dcn1-$i osp16-dcn1-1-$i & done; wait
	for i in 0 1 2; do openstack volume delete  osp16-dcn1-1-$i & done; wait
	for i in 0 1 2; do openstack volume create osp16-dcn1-1-$i --size 10 & done; wait
	for i in 0 1 2; do openstack server add volume osp16-dcn1-$i osp16-dcn1-1-$i & done; wait
}

function dcn2-create {
	set -x

	openstack server create --flavor m1.large --nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f,v4-fixed-ip=192.168.1.80 --image $IMAGE --key-name jslagle osp16-dcn2-0 &
	openstack server create --flavor m1.large --nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f,v4-fixed-ip=192.168.1.81 --image $IMAGE --key-name jslagle osp16-dcn2-1 &
	openstack server create --flavor m1.large --nic net-id=57167586-7aef-4f82-aeb7-42f0ca71005f,v4-fixed-ip=192.168.1.82 --image $IMAGE --key-name jslagle osp16-dcn2-2 &
	wait

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-dcn2-subnet,ip-address=192.168.26.20 --disable-port-security osp16-dcn2-0 &
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn2,ip-address=172.18.3.20 --disable-port-security osp16-dcn2-0-storagemgt &
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn2,ip-address=172.18.0.20 --disable-port-security osp16-dcn2-0-tenant &
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn2,ip-address=172.18.2.20 --disable-port-security osp16-dcn2-0-internalapi &
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn2,ip-address=172.18.1.20 --disable-port-security osp16-dcn2-0-storage &
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.23 --disable-port-security osp16-dcn2-0-external &

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-dcn2-subnet,ip-address=192.168.26.21 --disable-port-security osp16-dcn2-1 &
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn2,ip-address=172.18.3.21 --disable-port-security osp16-dcn2-1-storagemgt &
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn2,ip-address=172.18.0.21 --disable-port-security osp16-dcn2-1-tenant &
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn2,ip-address=172.18.2.21 --disable-port-security osp16-dcn2-1-internalapi &
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn2,ip-address=172.18.1.21 --disable-port-security osp16-dcn2-1-storage &
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.24 --disable-port-security osp16-dcn2-1-external &

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-dcn2-subnet,ip-address=192.168.26.22 --disable-port-security osp16-dcn2-2 &
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn2,ip-address=172.18.3.22 --disable-port-security osp16-dcn2-2-storagemgt &
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn2,ip-address=172.18.0.22 --disable-port-security osp16-dcn2-2-tenant &
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn2,ip-address=172.18.2.22 --disable-port-security osp16-dcn2-2-internalapi &
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn2,ip-address=172.18.1.22 --disable-port-security osp16-dcn2-2-storage &
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.25 --disable-port-security osp16-dcn2-2-external &
	wait

	while openstack server list | grep osp16-dcn2 | grep BUILD; do sleep 3; done

	openstack server add port osp16-dcn2-0 osp16-dcn2-0
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-storagemgt
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-tenant
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-internalapi
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-storage
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-external

	openstack server add port osp16-dcn2-1 osp16-dcn2-1
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-storagemgt
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-tenant
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-internalapi
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-storage
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-external

	openstack server add port osp16-dcn2-2 osp16-dcn2-2
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-storagemgt
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-tenant
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-internalapi
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-storage
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-external

	set +x
}

function dcn2-delete {
	set -x

	for i in 0 1 2; do openstack server remove volume osp16-dcn2-$i osp16-dcn2-$i & done; wait
	for i in 0 1 2; do openstack volume delete  osp16-dcn2-1-$i & done; wait

	for i in 0 1 2; do openstack server delete osp16-dcn2-$i & done; wait

	openstack port delete osp16-dcn2-0 &
	openstack port delete osp16-dcn2-0-storagemgt &
	openstack port delete osp16-dcn2-0-tenant &
	openstack port delete osp16-dcn2-0-internalapi &
	openstack port delete osp16-dcn2-0-storage &
	openstack port delete osp16-dcn2-0-external &
	openstack port delete osp16-dcn2-1 &
	openstack port delete osp16-dcn2-1-storagemgt &
	openstack port delete osp16-dcn2-1-tenant &
	openstack port delete osp16-dcn2-1-internalapi &
	openstack port delete osp16-dcn2-1-storage &
	openstack port delete osp16-dcn2-1-external &
	openstack port delete osp16-dcn2-2 &
	openstack port delete osp16-dcn2-2-storagemgt &
	openstack port delete osp16-dcn2-2-tenant &
	openstack port delete osp16-dcn2-2-internalapi &
	openstack port delete osp16-dcn2-2-storage &
	openstack port delete osp16-dcn2-2-external &
	wait
	set +x
}

function dcn2-volumes {
	for i in 0 1 2; do openstack server remove volume osp16-dcn2-$i osp16-dcn2-$i & done; wait
	for i in 0 1 2; do openstack volume delete  osp16-dcn2-$i & done; wait
	for i in 0 1 2; do openstack volume create osp16-dcn2-$i --size 10 & done; wait
	for i in 0 1 2; do openstack server add volume osp16-dcn2-$i osp16-dcn2-$i & done; wait
}


