export IMAGE="RHEL-8.2.1-x86_64-latest"

function create-osp16 {
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.1 --disable-port-security osp16-local-ip
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.2 --disable-port-security osp16-public-host
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.3 --disable-port-security osp16-admin-host
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.5 --disable-port-security osp16-external

	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16
	openstack server add port osp16 osp16-local-ip
	openstack server add port osp16 osp16-external
	openstack server rebuild --image $IMAGE osp16 &
}

function rebuild-controller {
	openstack server rebuild --image $IMAGE osp16-controller &
}

function create-controller {
	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16-controller

	# VIPs
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.100 --disable-port-security osp16-control-vip
	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.101 --disable-port-security osp16-ovndbs-vip
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt,ip-address=172.16.3.100 --disable-port-security osp16-storagemgt-vip
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant,ip-address=172.16.0.100 --disable-port-security osp16-tenant-vip
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi,ip-address=172.16.2.100 --disable-port-security osp16-internalapi-vip
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage,ip-address=172.16.1.100 --disable-port-security osp16-storage-vip
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.100 --disable-port-security osp16-external-vip
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.119 --disable-port-security osp16-public-vip

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.10 --disable-port-security osp16-controller
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt,ip-address=172.16.3.10 --disable-port-security osp16-controller-storagemgt
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant,ip-address=172.16.0.10 --disable-port-security osp16-controller-tenant
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi,ip-address=172.16.2.10 --disable-port-security osp16-controller-internalapi
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage,ip-address=172.16.1.10 --disable-port-security osp16-controller-storage
	openstack port create --network jslagle-osp16-external --fixed-ip subnet=jslagle-osp16-external,ip-address=10.0.0.10 --disable-port-security osp16-controller-external

	openstack server add port osp16-controller osp16-controller
	openstack server add port osp16-controller osp16-controller-storagemgt
	openstack server add port osp16-controller osp16-controller-tenant
	openstack server add port osp16-controller osp16-controller-internalapi
	openstack server add port osp16-controller osp16-controller-storage
	openstack server add port osp16-controller osp16-controller-external

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.100 --disable-port-security osp16-control-virtual-ip
}

function create-dcn1 {
	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16-dcn1-0 &
	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16-dcn1-1 &
	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16-dcn1-2 &
	wait

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.20 --disable-port-security osp16-dcn1-0
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn1,ip-address=172.16.4.20 --disable-port-security osp16-dcn1-0-storagemgt
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn1,ip-address=172.16.1.20 --disable-port-security osp16-dcn1-0-tenant
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn1,ip-address=172.16.3.20 --disable-port-security osp16-dcn1-0-internalapi
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn1,ip-address=172.16.2.20 --disable-port-security osp16-dcn1-0-storage

	openstack server add port osp16-dcn1-0 osp16-dcn1-0
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-storagemgt
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-tenant
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-internalapi
	openstack server add port osp16-dcn1-0 osp16-dcn1-0-storage

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.21 --disable-port-security osp16-dcn1-1
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn1,ip-address=172.16.4.21 --disable-port-security osp16-dcn1-1-storagemgt
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn1,ip-address=172.16.1.21 --disable-port-security osp16-dcn1-1-tenant
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn1,ip-address=172.16.3.21 --disable-port-security osp16-dcn1-1-internalapi
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn1,ip-address=172.16.2.21 --disable-port-security osp16-dcn1-1-storage

	openstack server add port osp16-dcn1-1 osp16-dcn1-1
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-storagemgt
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-tenant
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-internalapi
	openstack server add port osp16-dcn1-1 osp16-dcn1-1-storage

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.22 --disable-port-security osp16-dcn1-2
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn1,ip-address=172.16.4.22 --disable-port-security osp16-dcn1-2-storagemgt
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn1,ip-address=172.16.1.22 --disable-port-security osp16-dcn1-2-tenant
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn1,ip-address=172.16.3.22 --disable-port-security osp16-dcn1-2-internalapi
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn1,ip-address=172.16.2.22 --disable-port-security osp16-dcn1-2-storage

	openstack server add port osp16-dcn1-2 osp16-dcn1-2
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-storagemgt
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-tenant
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-internalapi
	openstack server add port osp16-dcn1-2 osp16-dcn1-2-storage
}

function delete-dcn1 {
	for i in 0 1 2; do openstack server delete osp16-dcn1-$i & done; wait

	openstack port delete osp16-dcn1-0 &
	openstack port delete osp16-dcn1-0-storagemgt &
	openstack port delete osp16-dcn1-0-tenant &
	openstack port delete osp16-dcn1-0-internalapi &
	openstack port delete osp16-dcn1-0-storage &
	openstack port delete osp16-dcn1-1 &
	openstack port delete osp16-dcn1-1-storagemgt &
	openstack port delete osp16-dcn1-1-tenant &
	openstack port delete osp16-dcn1-1-internalapi &
	openstack port delete osp16-dcn1-1-storage &
	openstack port delete osp16-dcn1-2 &
	openstack port delete osp16-dcn1-2-storagemgt &
	openstack port delete osp16-dcn1-2-tenant &
	openstack port delete osp16-dcn1-2-internalapi &
	openstack port delete osp16-dcn1-2-storage &
	wait
}

function dcn1-volumes {
	for i in 0 1 2; do openstack server remove volume osp16-dcn1-$i osp16-dcn1-1-$i & done; wait
	for i in 0 1 2; do openstack volume delete  osp16-dcn1-1-$i & done; wait
	for i in 0 1 2; do openstack volume create osp16-dcn1-1-$i --size 10 & done; wait
	for i in 0 1 2; do openstack server rebuild --image $IMAGE osp16-dcn1-$i --wait & done; wait
	for i in 0 1 2; do openstack server add volume osp16-dcn1-$i osp16-dcn1-1-$i & done; wait
}


function create-dcn2 {
	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16-dcn2-0 &
	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16-dcn2-1 &
	openstack server create --flavor m1.large --network jslagle-test --image $IMAGE --key-name jslagle osp16-dcn2-2 &

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.30 --disable-port-security osp16-dcn2-0
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn2,ip-address=172.16.5.20 --disable-port-security osp16-dcn2-0-storagemgt
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn2,ip-address=172.16.2.20 --disable-port-security osp16-dcn2-0-tenant
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn2,ip-address=172.16.4.20 --disable-port-security osp16-dcn2-0-internalapi
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn2,ip-address=172.16.3.20 --disable-port-security osp16-dcn2-0-storage

	openstack server add port osp16-dcn2-0 osp16-dcn2-0
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-storagemgt
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-tenant
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-internalapi
	openstack server add port osp16-dcn2-0 osp16-dcn2-0-storage

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.31 --disable-port-security osp16-dcn2-1
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn2,ip-address=172.16.5.21 --disable-port-security osp16-dcn2-1-storagemgt
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn2,ip-address=172.16.2.21 --disable-port-security osp16-dcn2-1-tenant
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn2,ip-address=172.16.4.21 --disable-port-security osp16-dcn2-1-internalapi
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn2,ip-address=172.16.3.21 --disable-port-security osp16-dcn2-1-storage

	openstack server add port osp16-dcn2-1 osp16-dcn2-1
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-storagemgt
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-tenant
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-internalapi
	openstack server add port osp16-dcn2-1 osp16-dcn2-1-storage

	openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.32 --disable-port-security osp16-dcn2-2
	openstack port create --network jslagle-osp16-storagemgt --fixed-ip subnet=jslagle-osp16-storagemgt-dcn2,ip-address=172.16.5.22 --disable-port-security osp16-dcn2-2-storagemgt
	openstack port create --network jslagle-osp16-tenant --fixed-ip subnet=jslagle-osp16-tenant-dcn2,ip-address=172.16.2.22 --disable-port-security osp16-dcn2-2-tenant
	openstack port create --network jslagle-osp16-internalapi --fixed-ip subnet=jslagle-osp16-internalapi-dcn2,ip-address=172.16.4.22 --disable-port-security osp16-dcn2-2-internalapi
	openstack port create --network jslagle-osp16-storage --fixed-ip subnet=jslagle-osp16-storage-dcn2,ip-address=172.16.3.22 --disable-port-security osp16-dcn2-2-storage

	openstack server add port osp16-dcn2-2 osp16-dcn2-2
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-storagemgt
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-tenant
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-internalapi
	openstack server add port osp16-dcn2-2 osp16-dcn2-2-storage
}

function dcn2-volumes {
	for i in 0 1 2; do openstack server remove volume osp16-dcn2-$i osp16-dcn2-$i & done; wait
	for i in 0 1 2; do openstack volume delete  osp16-dcn2-$i & done; wait
	for i in 0 1 2; do openstack volume create osp16-dcn2-$i --size 10 & done; wait
	for i in 0 1 2; do openstack server rebuild --image $IMAGE osp16-dcn2-$i --wait & done; wait
	for i in 0 1 2; do openstack server add volume osp16-dcn2-$i osp16-dcn2-$i & done; wait
}
