function create_networks {

    openstack network create --internal --disable-port-security jslagle-osp13
    openstack subnet create --gateway none --no-dhcp --network jslagle-osp13 --subnet-range 192.168.24.0/24 jslagle-osp13

    openstack port create \
        --fixed-ip ip-address=192.168.24.2 \
        --network jslagle-osp13 \
        osp13-local-ip &

    openstack port create \
        --fixed-ip ip-address=192.168.24.3 \
        --network jslagle-osp13 \
        osp13-admin-host &

    openstack port create \
        --fixed-ip ip-address=192.168.24.4 \
        --network jslagle-osp13 \
        osp13-public-host &

}


function create_osp13_uc {
    osp13_local_ip=$(openstack port show osp13-local-ip -f value -c id)

    openstack server create \
        --flavor quicklab.ocp4.master \
        --image RHEL-7.9-x86_64-ga-latest \
        --key-name jslagle \
        --nic net-id=a7445861-bb5b-40b3-bafa-bea9fdabb322 \
        --nic port-id=$osp13_local_ip \
        --wait \
        osp13-uc

    openstack server add floating ip osp13-uc 10.0.126.30
}



function create_osp13_controllers {

    net_id=$(openstack network show -f value -c id jslagle-osp13)
    for i in 0 1 2; do
        openstack server create \
            --flavor ocp-master-large \
            --image RHEL-7.9-x86_64-ga-latest \
            --key-name jslagle \
            --nic net-id=a7445861-bb5b-40b3-bafa-bea9fdabb322 \
            --nic net-id=${net_id},v4-fixed-ip=192.168.24.1${i} \
            osp13-controller-${i} &
    done
    wait

}

function create_osp13_computes {

    net_id=$(openstack network show -f value -c id jslagle-osp13)
    for i in 0; do
        openstack server create \
            --flavor m1.large \
            --image RHEL-7.9-x86_64-ga-latest \
            --key-name jslagle \
            --nic net-id=a7445861-bb5b-40b3-bafa-bea9fdabb322 \
            --nic net-id=${net_id},v4-fixed-ip=192.168.24.10${i} \
            osp13-compute-${i} &
    done
    wait

}
