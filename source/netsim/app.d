module netsim.app;

import netsim.network.iface;
import netsim.network.nodes.qemu;
import netsim.network.nodes.docker;

import std.stdio;

import core.thread : Thread;
import core.time : Duration;

void main()
{
  QemuNode node1 = new QemuNode("../img/alpine-extended-3.14.0-x86_64.iso", "AA:AA:AA:AA:AA:AA");
  DockerNode node2 = new DockerNode;

  NetworkInterface node1_eth0 = node1.getInterfaces()[0];
  NetworkInterface node2_eth0 = node2.getInterfaces()[0];

  node1_eth0.connect(node2_eth0);

  writefln!"Docker container id: %s"(node2.getContainerId);

  while (true)
    Thread.sleep(Duration.max);
}
