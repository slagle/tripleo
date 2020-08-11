openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.1 --disable-port-security osp16-local-ip
openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.2 --disable-port-security osp16-public-host
openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.3 --disable-port-security osp16-admin-host

openstack server add port osp16 osp16-local-ip

openstack server create --flavor m1.large --network jslagle-test --image  RHEL-8.1.0-x86_64-latest --key-name jslagle osp16-controller

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
