module netsim.app;

import netsim.network.iface;
import netsim.network.nodes.qemu;
import netsim.network.nodes.docker;

import std.stdio;
import std.process;
import std.format;

import core.thread : Thread;
import core.time : Duration;

void main()
{
  writeln("Spawning nodes");
  DockerNode docker1 = new DockerNode("docker 1");
  // DockerNode docker2 = new DockerNode("docker 2");
  QemuNode qemu1 = new QemuNode("qemu 1", "../img/alpine-extended-3.14.0-x86_64.iso", "AA:AA:AA:AA:AA:AA");

  writeln("Connecting nodes");
  NetworkInterface docker1_eth0 = docker1.getInterfaces()[0];
  // NetworkInterface docker2_eth0 = docker2.getInterfaces()[0];
  NetworkInterface qemu1_eth0 = qemu1.getInterfaces()[0];

  docker1_eth0.connect(qemu1_eth0);

  executeShell(format!"docker exec %s ip link set dev eth0 up"(docker1.getContainerId));
  executeShell(format!"docker exec %s ip addr add 10.0.0.1/24 dev eth0"(docker1.getContainerId));

  writefln!"Docker 1 container id: %s"(docker1.getContainerId);
  writefln!"Docker 1 container pid: %d"(docker1.getContainerPid);
  // writefln!"Docker 2 container id: %s"(docker2.getContainerId);
  // writefln!"Docker 2 container pid: %d"(docker2.getContainerPid);

  while (true)
    Thread.sleep(Duration.max);
}
