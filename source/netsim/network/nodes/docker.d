module netsim.network.nodes.docker;

import netsim.network.nodes.docker_utils.ns;
import netsim.network.nodes.docker_utils.tap;

import netsim.graph.graph;
import netsim.network.iface;
import netsim.network.node;
import netsim.utils.exception;

import std.exception : enforce;
import std.format : format, formattedRead;
import std.format : format;
import std.process : execute;
import std.stdio : File;
import std.string : fromStringz;
import std.uuid : UUID;

import core.stdc.errno : EAGAIN, errno, EWOULDBLOCK;
import core.stdc.string : strerror;
import core.sys.posix.unistd : read, write;

debug import std.stdio : writeln, writefln;

enum image = "weibeld/ubuntu-networking";

/** 
 * A docker container
 */
final class DockerNode : Node, GraphNode
{
  private UUID id;
  private string name;
  private DockerInterface[] interfaces;

  private string containerId; // 64-char id
  private int containerPid; // The external pid of pid 1 in the container

  public this(UUID id, string name)
  {
    this.id = id;
    this.name = name;

    // Pull image (should probably be done globally)
    auto pullResult = execute(["docker", "pull", image]);
    if (pullResult.status != 0)
      throw new NodeException(this,
        format!"docker pull returned non-zero status code %d with output '%s'"(
          pullResult.status,
          pullResult.output
      ));

    // Run container
    // If successful, this command prints the 64-char id of the container (plus a newline)
    auto runResult = execute([
      "docker", "run", "-d", "--rm", "--network=none", "--cap-add=NET_ADMIN",
      image, "sleep", "inf"
    ]);
    if (runResult.status != 0)
      throw new NodeException(this,
        format!"docker run returned non-zero status code %d with output '%s'"(
          runResult.status,
          runResult.output
      ));
    if (runResult.output.length != 65)
      throw new NodeException(this,
        format!"unexpected docker run output: '%s' (expected 64-char id + a newline)"(
          runResult.output));

    // Store container id
    runResult.output.formattedRead!"%s\n"(containerId);

    // Get external pid of container pid 1
    // If successful, this command prints external pid and a newline
    auto getPidResult = execute([
      "docker", "inspect", "--format={{ .State.Pid }}", containerId
    ]);
    if (getPidResult.status != 0)
      throw new NodeException(this,
        format!"docker inspect returned non-zero status code %d with output '%s'"(
          getPidResult.status,
          getPidResult.output
      ));

    // Store pid
    getPidResult.output.formattedRead!"%d\n"(containerPid);

    addInterface("eth0");
    addInterface("eth1");
    addInterface("eth2");
    addInterface("eth3");
  }

  ~this()
  {
    writeln("Destructing " ~ toString);

    foreach (iface; interfaces)
      destroy(iface);

    auto stopResult = execute([
        "docker", "stop", "--time=4", containerId
      ]);
    if (stopResult.status != 0)
      throw new NodeException(this,
        format!"docker stop returned non-zero status code %d with output '%s'"(
          stopResult.status,
          stopResult.output
      ));
  }

  override public string getName() const
  {
    return name;
  }

  public static NodeType getType()
  {
    return NodeType.Docker;
  }

  override public string toString() const
  {
    return format!"%s node %s"(getType, getName);
  }

  override public NetworkInterface[] getInterfaces() const
  {
    return cast(NetworkInterface[]) interfaces;
  }

  public NetworkInterface addInterface(string name)
  {
    File tap;

    doInNetNamespace(containerPid, () {
      // Create and open tap
      createTap(name);
      tap = openTap(name);
    });

    DockerInterface iface = new DockerInterface(name, this, tap);
    interfaces ~= iface;
    return iface;
  }

  public string getContainerId() const
  {
    return containerId;
  }

  public int getContainerPid() const
  {
    return containerPid;
  }

  mixin emptyResolveMixin;
  mixin queryMixin!(getName, getType, getContainerId, getContainerPid);
}

private class DockerInterface : NetworkInterface
{
  File tap;
  ubyte[65_536] outgoingBuffer;

  this(string name, DockerNode node, File tap)
  {
    super(name, cast(Node) node);
    this.tap = tap;
  }

  override void handleIncoming(ubyte[] frame)
  {
    debug writefln("Incoming frame of %d bytes to node %s interface %s", frame.length, getNode, this);

    long result = write(tap.fileno, cast(void*) frame.ptr, frame.length);

    if (result == -1)
    {
      if (errno == EAGAIN || errno == EWOULDBLOCK)
      {
        // writefln("yielding handleIncoming %s %s", getNode.toString, toString);
        yield;
      }
      else
        throw new NodeInterfaceException(getNode, this,
          format!"write to tap failed with errno %d and strerror %s"(errno, strerror(errno))
        );
    }
    else if (result != frame.length)
      throw new NodeInterfaceException(getNode, this,
        format!"not all bytes were written to docker tap: %d out of %d bytes"(result, frame.length)
      );
  }

  override ubyte[] generateOutgoing()
  {
    while (true)
    {
      long result = read(tap.fileno, cast(void*)&outgoingBuffer, outgoingBuffer.sizeof);

      if (result == -1)
      {
        if (errno == EAGAIN || errno == EWOULDBLOCK)
        {
          // debug writefln("yielding generateOutgoing %s %s", getNode.toString, toString);
          yield;
        }
        else
          throw new NodeInterfaceException(getNode, this,
            format!"read from tap failed with errno %d and strerror %s"(errno, strerror(errno))
          );
      }
      else
      {
        debug writefln("Frame with %d bytes outgoing from node %s interface %s", result, getNode, this);
        return outgoingBuffer[0 .. result];
      }
    }
  }
}
