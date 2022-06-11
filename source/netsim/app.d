module netsim.app;

import netsim.network.iface;
import netsim.network.nodes.hub;
import netsim.network.nodes.qemu;

import core.thread : Thread;
import core.time : Duration;

void main()
{
  QemuNode node1 = new QemuNode("../img/alpine-extended-3.14.0-x86_64.iso", "AA:AA:AA:AA:AA:AA");
  QemuNode node2 = new QemuNode("../img/alpine-extended-3.14.0-x86_64.iso", "AA:AA:AA:AA:AA:AB");
  Hub hub = new Hub();

  NetworkInterface node1_eth0 = node1.getInterfaces()[0];
  NetworkInterface node2_eth0 = node2.getInterfaces()[0];
  NetworkInterface hub_if1 = hub.addInterface("if1");
  NetworkInterface hub_if2 = hub.addInterface("if2");

  hub_if1.connect(node1_eth0);
  hub_if2.connect(node2_eth0);

  while (true)
    Thread.sleep(Duration.max);
}
