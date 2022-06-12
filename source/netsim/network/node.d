module netsim.network.node;

import netsim.network.iface : NetworkInterface;

import std.format : format;

interface Node
{
  string getName() const;
  NodeType getType() const;
  string toString() const;
  NetworkInterface[] getInterfaces() const;
}

enum NodeType : int
{
  Invalid = 0,
  Qemu = 1,
  Docker = 2
}

class NodeException : Exception
{
  public Node node;

  this(Node node, string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
  {
    super(format!"In node %s, %s"(node.toString, msg), file, line, nextInChain);
    this.node = node;
  }
}

class NodeInterfaceException : NodeException
{
  public NetworkInterface iface;

  this(Node node, NetworkInterface iface, string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
  {
    super(node, format!"in interface %s, %s"(iface.toString, msg), file, line, nextInChain);
    this.iface = iface;
  }
}
