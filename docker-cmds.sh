#!/usr/bin/env bash

c1=
c2=

docker exec $c1 ip link set dev eth0 up
docker exec $c1 ip addr add 10.0.0.1/24 dev eth0

docker exec $c2 ip link set dev eth0 up
docker exec $c2 ip addr add 10.0.0.2/24 dev eth0

docker exec $c2 ping 10.0.0.1