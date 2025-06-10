module netsim.network.iface;

public import netsim.core.fiber : yield;

import netsim.core.fiber;
import netsim.network.node;

import std.exception : enforce;
import std.format : format;

/** 
 * Represents an interface that can exchange layer 2 frames with exactly one other interface.
 * Interfaces exchange frames using `other.handleIncoming(generateOutgoing())` in the `outgoingLoop`.
 */
abstract class NetworkInterface
{
  private string name;
  private Node node;
  private NetworkInterface connected;
  private Fiber fiber;

  protected this(string name, Node node) @trusted
  in (name.length > 0)
  {
    this.name = name;
    this.node = node;
    this.fiber = new Fiber(&outgoingLoop);
  }

  public ~this()
  {
    ConnectedInterfacePair pair = getConnectedPair;
    if (pair !is null)
      pair.disconnect;
  }

  public final string getName() const
  {
    return name;
  }

  public final Node getNode()
  {
    return node;
  }

  override string toString() const
  {
    return format!"interface %s"(getName);
  }

  /**
   * Gets the `ConnectedInterfacePair` representing the connection between this and another `NetworkInterface`.
   *
   * Returns: An instance of `ConnectedInterfacePair`, or `null` if this interface isn't connected.
   */
  public final ConnectedInterfacePair getConnectedPair()
  {
    if (connected is null)
      return null;
    return new ConnectedInterfacePair(this, connected);
  }

  public final bool isConnected()
  {
    return connected !is null;
  }

  /**
   * Connects 2 `NetworkInterface` objects.
   *
   * Params: 
   *   to = The other interface.
   * Returns: A `ConnectedInterfacePair` object representing the connection.
   */
  public final ConnectedInterfacePair connect(NetworkInterface to)
  {
    enforce(connected is null, "This interface is already connected");
    enforce(to.connected is null, "The argument interface is already connected");

    connected = to;
    registerOutgoingLoopFiber();

    to.connected = this;
    to.registerOutgoingLoopFiber();

    return getConnectedPair();
  }

  /// Called by ConnectedInterfacePair
  private void disconnect()
  {
    connected = null;
    unRegisterOutgoingLoopFiber();
  }

  // Incoming frames

  /*
   * Will be called for every incoming frame.
   * The frame should be sent to the undelying machine/node/.. in this method.
   *
   * This method should call `yield()` when:
   *   - Waiting on I/O operations to complete
   *   - The interface's node is not yet ready to accept the frame
   */
  protected abstract void handleIncoming(ubyte[] frame); // TODO: Pcap, check if connected

  // Outgoing frames

  private void registerOutgoingLoopFiber()
  {
    auto manager = FiberManager.getInstance();
    manager.register(fiber, FiberType.LOOPBACK, format!"Interface '%s' send outgoing loop"(name));
  }

  private void unRegisterOutgoingLoopFiber()
  {
    auto manager = FiberManager.getInstance();
    assert(manager.isRegistered(fiber), "Fiber wasn't registered");
    manager.unRegister(fiber);
  }

  private void outgoingLoop()
  {
    while (true)
    {
      if (isConnected)
        connected.handleIncoming(generateOutgoing());
      yield();
    }
  }

  /**
   * Will be called repeatedly.
   * Every call should return a frame or yield indefinitely.
   *
   * The implementation should call `yield()` while:
   *   - Waiting for I/O operations to complete
   *   - Waiting for new frames
   */
  protected abstract ubyte[] generateOutgoing();
}

final class ConnectedInterfacePair
{
  NetworkInterface if1, if2;

  this(NetworkInterface if1, NetworkInterface if2)
  {
    this.if1 = if1;
    this.if2 = if2;
  }

  /** 
   * Disconnects the interface pair.
   * 
   * This instance becomes invalid after calling it.
   */
  public void disconnect()
  {
    if1.disconnect();
    if2.disconnect();
  }

  public NetworkInterface getComplementOf(NetworkInterface iface)
  {
    if (if1 == iface)
      return if1;
    else if (if2 == iface)
      return if2;
    else
      throw new Exception("Argument interface is not part of this pair");
  }

  // TODO: getters, pcap
}
