module netsim.core.hostos;

final class LoopbackManager
{
  // Lazy singleton
  private __gshared LoopbackManager instance;

  public static LoopbackManager getInstance()
  {
    if (instance is null)
      synchronized (LoopbackManager.classinfo)
        instance = new LoopbackManager("127.90.0.1", 8);
    return instance;
  }

  // Instance
  private string address;
  private int subnet;

  private ushort nextPort = 10_000;

  private this(string address, int subnet)
  in (address.length > 0)
  in (subnet > 0 && subnet <= 32)
  {
    this.address = address;
    this.subnet = subnet;
  }

  public string getAddress() const
  {
    return address;
  }

  // TODO split udp/tcp?
  public ushort reservePort()
  {
    synchronized (LoopbackManager.classinfo)
      return nextPort++;
  }

  public void freePort(int port)
  {
    // TODO: implement and add proper tracking of used ports and their owners
  }
}
