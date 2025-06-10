module netsim.network.node;

import netsim.graph.graph : GraphNode;
import netsim.network.iface : NetworkInterface;
import netsim.network.nodes.docker;
import netsim.network.nodes.qemu;

import std.exception : enforce;
import std.format : format;

interface Node : GraphNode
{
  string getName() const;
  static NodeType getType();
  string toString() const;
  NetworkInterface[] getInterfaces() const;
}

enum NodeType : int
{
  Invalid = 0,
  Docker = 1,
  Qemu = 2
}

/** 
 * Casts `node` to one of the classes implemening Node based on `type``.
 * This just does the (unsafe) casting.
 */
auto nodeCast(NodeType type)(Node node) @trusted
{
  enforce(node.getType == type, format!"node.getType (%s) is different from the provided type (%s)", node.getType, type);
  with (NodeType)
  {
    switch (type)
    {
    case Docker:
      return cast(DockerNode) node;
    case Qemu:
      return cast(QemuNode) node;
    default:
      assert(false, "Invalid node (node.getType is invalid)");
    }
  }
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
