module netsim.network.node;

import netsim.network.iface : NetworkInterface;

interface Node
{
  NetworkInterface[] getInterfaces();
}