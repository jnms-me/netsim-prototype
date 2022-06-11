module netsim.network.nodes.docker;

import netsim.network.nodes.docker_utils.ns;
import netsim.network.nodes.docker_utils.tap;

import netsim.network.iface;
import netsim.network.node;

import std.exception : enforce, errnoEnforce;
import std.format : format, formattedRead;
import std.process : execute;
import std.stdio : File;

import core.sys.posix.unistd : read, write;

/** 
 * A docker container
 */
final class DockerNode : Node
{
  private DockerInterface[] interfaces;

  private string containerId; // 64-char id
  private int containerPid; // The external pid of pid 1 in the container

  public this()
  {
    // Run container
    // If successful, this command prints the 64-char id of the container (plus a newline)
    auto runResult = execute([
      "docker", "run", "-d", "--rm", "--network=none", "ubuntu",
      "sleep", "inf"
    ]);
    enforce(
      runResult.status == 0,
      format!"docker run returned non-zero status code %d with output '%s'"(
        runResult.status,
        runResult.output
    ));
    assert(runResult.output.length == 65);

    // Store container id
    runResult.output.formattedRead!"%s\n"(containerId);

    // Get external pid of container pid 1
    // If successful, this command prints external pid and a newline
    auto getPidResult = execute([
      "docker", "inspect", "--format={{ .State.Pid }}", containerId
    ]);
    enforce(getPidResult.status == 0,
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

  override public NetworkInterface[] getInterfaces()
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

    DockerInterface iface = new DockerInterface(name, tap);
    interfaces ~= iface;
    return iface;
  }

  public string getContainerId()
  {
    return containerId;
  }
}

private class DockerInterface : NetworkInterface
{
  File tap;
  ubyte[65_536] outgoingBuffer;

  this(string name, File tap)
  {
    super(name);
    this.tap = tap;
  }

  override void handleIncoming(ubyte[] frame)
  {
    long result = write(tap.fileno, cast(void*) frame.ptr, frame.length);

    errnoEnforce(result != -1, "write to docker tap failed");

    assert(result == frame.length,
      format!"not all bytes were written in write to docker tap: %d out of %d bytes"(
        result, frame.length
    ));
  }

  override ubyte[] generateOutgoing()
  {
    long result;

    while ((result = read(tap.fileno, cast(void*)&outgoingBuffer, outgoingBuffer.sizeof)) == 0)
      yield();

    errnoEnforce(result != -1, "read from docker tap failed");

    return outgoingBuffer[0 .. result];
  }
}
