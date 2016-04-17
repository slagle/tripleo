ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex eth1 -- set interface eth1 type=internal
ip link set dev br-ex up

ip addr add 192.0.2.1/24 dev eth1
ip link set eth1 up


ip addr add 192.0.2.2/24 dev eth1
ip link set eth1 up

ovs-vsctl add-port br-ex tun0 -- \
    set interface tun0 type=gre \
    options:remote_ip=192.168.122.134

ovs-vsctl add-port br-ex tun0 -- \
    set interface tun0 type=gre \
    options:remote_ip=192.168.122.196


ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex eth2 -- set interface eth2 type=internal
ip link set dev br-ex up

ip addr add 192.0.2.1/24 dev eth2
ip link set eth2 up


ip addr add 192.0.2.2/24 dev eth2
ip link set eth2 up

ovs-vsctl add-port br-ex tun0 -- \
    set interface tun0 type=gre \
    options:remote_ip=10.176.9.187

ovs-vsctl add-port br-ex tun0 -- \
    set interface tun0 type=gre \
    options:remote_ip=10.176.8.188

