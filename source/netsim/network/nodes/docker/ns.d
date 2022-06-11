module netsim.network.nodes.docker.ns;

import std.stdio : File;
import std.conv : to;

extern (C) int setns(int fd, int nstype);

/** 
 * Calls dg in the network namespace of pid.
 * This thread will be moved to the namespace of pid 1 (the real one) after returning.
 */
void doInNetNamespace(int pid, void delegate() dg)
{
  changeNetNs(pid);
  dg();
  changeNetNs(1);
}

void changeNetNs(int pid)
in (pid > 0)
{
  auto nsfile = File("/proc/" ~ pid.to!string ~ "/ns/net", "r");
  scope (exit)
    nsfile.close;

  if (setns(nsfile.fileno, 0) == -1)
    throw new Exception("setns failed");
}
