module netsim.app;

import netsim.network.iface;
import netsim.network.nodes.qemu;
import netsim.network.nodes.docker;

import std.stdio;

import core.thread : Thread;
import core.time : Duration;

void main()
{
  writeln("Spawning nodes");
  // QemuNode node1 = new QemuNode("qemu 1", "../img/alpine-extended-3.14.0-x86_64.iso", "AA:AA:AA:AA:AA:AA");
  DockerNode node1 = new DockerNode("docker 1");
  DockerNode node2 = new DockerNode("docker 2");

  writeln("Connecting nodes");
  NetworkInterface node1_eth0 = node1.getInterfaces()[0];
  NetworkInterface node2_eth0 = node2.getInterfaces()[0];

  node1_eth0.connect(node2_eth0);

  writeln;
  writefln!"c1=%s"(node1.getContainerId);
  writefln!"c2=%s"(node2.getContainerId);
  writeln;
  writefln!"Docker 1 container id: %s"(node1.getContainerId);
  writefln!"Docker 1 container pid: %d"(node1.getContainerPid);
  writefln!"Docker 2 container id: %s"(node2.getContainerId);
  writefln!"Docker 2 container pid: %d"(node2.getContainerPid);

  while (true)
    Thread.sleep(Duration.max);
}
