module netsim.app;

import netsim.netsim;

import netsim.network.iface;
import netsim.network.nodes.qemu;
import netsim.network.nodes.docker;

import std.stdio;
import std.process;
import std.format;
import std.uuid;

import core.thread : Thread;
import core.time : Duration;

import core.sys.posix.signal : sigaction, sigaction_t, sigemptyset, SA_RESTART, SIGINT;

void main()
{
  Netsim netsim = new Netsim;

  import core.thread;

  while (true)
  {
    Thread.sleep(Duration.max);
  }
}

/*
DockerNode docker1;
// DockerNode docker2;
QemuNode qemu1;

void main()
{
  writeln(randomUUID, "Spawning nodes");
  docker1 = new DockerNode(randomUUID, "docker 1");
  // docker2 = new DockerNode("docker 2");
  qemu1 = new QemuNode(randomUUID, "qemu 1", "../img/alpine-extended-3.14.0-x86_64.iso", "AA:AA:AA:AA:AA:AA");

  extern (C) void cleanUp(int sig)
  {
    writeln;
    writeln("Received SIGINT");
    destroy(docker1);
    // destroy(docker2);
    destroy(qemu1);
    return;
  }

  sigaction_t sa;
  sa.sa_handler = &cleanUp;
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = SA_RESTART;
  sigaction(SIGINT, &sa, null);

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
*/
