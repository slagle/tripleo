openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.1 --disable-port-security osp16-local-ip
openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.2 --disable-port-security osp16-public-host
openstack port create --network jslagle-osp16 --fixed-ip subnet=jslagle-osp16-subnet,ip-address=192.168.24.3 --disable-port-security osp16-admin-host

openstack server add port osp16 osp16-local-ip
