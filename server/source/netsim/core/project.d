module netsim.core.project;

import netsim.graph.graph;
import netsim.network.node;
import netsim.network.iface;
import netsim.network.nodes.docker;
import netsim.network.nodes.qemu;

import std.algorithm : map;
import std.array : array;
import std.conv : to;
import std.exception : enforce;
import std.format : format;
import std.json : JSONValue;
import std.uuid : randomUUID, UUID;

final class Project : GraphNode
{
  private UUID id;
  private string name;

  private Node[UUID] nodes;

  //
  // Constructors / Destructor
  //

  this(UUID id, string name)
  {
    this.id = id;
    this.name = name;
  }

  ~this()
  {
    foreach (node; nodes)
      destroy(node);
  }

  //
  // Adding nodes
  //

  void addDockerNode(UUID id, string name)
  {
    nodes[id] = cast(Node) new DockerNode(id, name);
    nodes.rehash;
  }

  void addQemuNode(UUID id, string name, string image, string mac)
  {
    nodes[id] = cast(Node) new QemuNode(id, name, image, mac);
    nodes.rehash;
  }

  string createDockerTestNode()
  {
    UUID nodeId = randomUUID;
    addDockerNode(id, "docker 1");
    return nodeId.toString;
  }

  string createQemuTestNode()
  {
    UUID nodeId = randomUUID;
    addQemuNode(nodeId, "qemu 1", "../img/alpine-extended-3.14.0-x86_64.iso", "AA:AA:AA:AA:AA:AA");
    return nodeId.toString;
  }

  //
  // Removing nodes
  //

  void removeNode(UUID id)
  {
    enforce(nodeExists(id), format!"removeNode failed: node with id %s does not exist in this project"(
        id));
    bool result = nodes.remove(id);
    assert(result);
  }

  //
  // Accessing nodes
  //

  Node[] getNodes()
  {
    return nodes.values;
  }

  bool nodeExists(UUID id)
  {
    return (id in nodes) !is null;
  }

  Node getNode(UUID id)
  {
    Node* node = id in nodes;
    enforce(node !is null, format!"getNode failed: node with id %s does not exist in this project"(
        id));
    return *node;
  }

  UUID[] listNodeIds()
  {
    return nodes.keys;
  }

  bool connectNodes(UUID id1, UUID id2)
  {
    enforce((id1 in nodes) !is null);
    enforce((id2 in nodes) !is null);
    NetworkInterface if1 = nodes[id1].getInterfaces[0];
    NetworkInterface if2 = nodes[id2].getInterfaces[0];
    if1.connect(if2);
    return true;
  }

  //
  // Implementing GraphNode
  //

  Node[] graph_getNodes() => getNodes;
  bool graph_nodeExists(string id) => nodeExists(UUID(id));
  Node graph_getNode(string id) => getNode(UUID(id));
  string[] graph_listNodeIds() => listNodeIds.map!(id => id.toString).array;

  string graph_createDockerTestNode() => createDockerTestNode;
  string graph_createQemuTestNode() => createQemuTestNode;
  bool graph_connectNodes(string id1, string id2) => connectNodes(UUID(id1), UUID(id2));

  mixin resolveMixin!(graph_getNode);
  mixin queryMixin!(
    graph_getNodes, graph_nodeExists, graph_getNode, graph_listNodeIds,
    graph_createDockerTestNode, graph_createQemuTestNode, graph_connectNodes
  );

  JSONValue _toJSON() const @safe
  {
    return JSONValue(["id": id.toString, "name": name]);
  }
}
