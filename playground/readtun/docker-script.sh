ifname=netsim-tap

ip tuntap add $ifname mode tap user root
ip link set dev $ifname up
ip addr add 10.0.0.1/24 dev $ifname
ip rout add default via 10.0.0.254 dev $ifname
