module netsim.network.nodes.qemu;

import netsim.hostos : LoopbackManager;
import netsim.network.iface;
import netsim.network.node;

import std.conv : to;
import std.process : Pid, spawnProcess;
import std.socket : InternetAddress, Socket, UdpSocket, wouldHaveBlocked;

final class QemuNode : Node
{
  private QemuSocketInterface[] interfaces;
  private Pid pid;

  public this(string image, string mac)
  {
    interfaces ~= new QemuSocketInterface("eth0");

    string executable = "/usr/bin/qemu-system-x86_64";
    string[] args;
    args ~= ["-smp", "cores=2"];
    args ~= ["-m", "2048"];
    args ~= ["-cdrom", image];
    args ~= ["-device", "e1000,netdev=net0,mac=" ~ mac];
    args ~= ["-netdev", interfaces[0].toNetdevArgString("net0")];

    pid = spawnProcess([executable] ~ args);
  }

  override public NetworkInterface[] getInterfaces()
  {
    return cast(NetworkInterface[]) interfaces;
  }
}

/** 
 * Represents a connection to a single qemu `socket` network backend over a local udp bus.
 * Instances should be created before creating the qemu process, the process should then be started with `toNetdevArgString()` as an argument.
 */
private class QemuSocketInterface : NetworkInterface
{
  private InternetAddress ourAddress;
  private InternetAddress qemuAddress;

  private UdpSocket conn;
  private ubyte[65_536] outgoingBuffer;

  public this(string name)
  {
    super(name);
    auto lo = LoopbackManager.getInstance();
    string address = lo.getAddress();
    ourAddress = new InternetAddress(address, lo.reservePort());
    qemuAddress = new InternetAddress(address, lo.reservePort());

    conn = new UdpSocket();
    assert(conn.isAlive);
    conn.blocking = false;

    // Listen on this address only
    conn.bind(ourAddress);
    // Setup the connection to always send back to qemu (udp is connectionless)
    conn.connect(qemuAddress);
  }

  public ~this()
  {
    conn.close();
  }

  override void handleIncoming(ubyte[] frame)
  {
    bool firstRun = true;
    ptrdiff_t result;

    // Keep trying until the message is accepted (should never loop)
    do
    {
      if (!firstRun)
        yield();
      else
        firstRun = false;

      result = conn.send(frame);
    }
    while (result == Socket.ERROR && wouldHaveBlocked());
  }

  override ubyte[] generateOutgoing()
  {
    while (true)
    {
      bool firstRun = true;
      ptrdiff_t result;

      // Repeat until there is a message
      do
      {
        if (!firstRun)
          yield();
        else
          firstRun = false;

        result = conn.receive(outgoingBuffer[]);
      }
      while (result == Socket.ERROR && wouldHaveBlocked());

      assert(result != Socket.ERROR);
      assert(result >= 0);
      return outgoingBuffer[0 .. result];
    }
  }

  /** 
   * Params:
   *   netId = The qemu network id, must be unique for every interface in a qemu process.
   * Returns: An argument to the `-netdev` qemu option, set up to use this interface.
   */
  public string toNetdevArgString(string netId)
  {
    import std.format : format;

    // Example: -netdev socket,id=net0,udp=127.0.0.1:63000,localaddr=127.0.0.1:63100
    return format("socket,id=%s,udp=%s,localaddr=%s", netId, ourAddress, qemuAddress);
  }
}
