#!/usr/bin/env bash

if [[ $UID -ne 0 ]]; then
    echo Run as root
    exit 1
fi

container=ubuntu
container_pid=$(docker inspect --format '{{ .State.Pid }}' ubuntu)

echo Container pid: $container_pid

echo
echo All namespaces:
readlink /proc/*/ns/net | sort | uniq

echo
echo Container namespace: $(readlink /proc/$container_pid/ns/net)
