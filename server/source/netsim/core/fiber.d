/// Fibers mainly for network interface send/receive loops
module netsim.core.fiber;

public import core.thread : Fiber;

import core.thread : Thread, ThreadGroup;
import std.algorithm : filter, remove;

/** 
 * If called from a fiber, yields the fiber.
 * Calling this from a normal thread has *no effect*.
 * Call this when waiting on I/O.
 */
void yield()
{
  if (Fiber.getThis() !is null)
    Fiber.yield();
}

enum FiberType
{
  LOOPBACK
}

final class FiberManager
{
  // Lazy singleton
  private __gshared FiberManager instance;

  public static FiberManager getInstance()
  {
    if (instance is null)
      synchronized (FiberManager.classinfo)
        instance = new FiberManager();
    return instance;
  }

  // Instance
  private struct RegisteredFiber
  {
    Fiber fiber;
    FiberType type;
    string name;

    this(Fiber fiber, FiberType type, string name = "")
    in (fiber !is null)
    {
      this.fiber = fiber;
      this.type = type;
      this.name = name;
    }

    alias fiber this;
  }

  private ThreadGroup threads;
  private __gshared RegisteredFiber[] fibers;

  private this()
  {
    threads = new ThreadGroup();
    threads.create(() => run(FiberType.LOOPBACK));
  }

  private void run(FiberType type)
  {
    while (true)
    {
      foreach (RegisteredFiber fiber; fibers.filter!(f => f.type == type))
      {
        assert(fiber.state == Fiber.State.HOLD);
        // Todo: catch and log errors. Right now it silently crashes, but logs when the program is terminated.
        fiber.call();
        assert(fiber.state == Fiber.State.HOLD);
      }
    }
  }

  public bool isRegistered(Fiber fiber)
  {
    return !fibers.filter!(f => f.fiber == fiber).empty;
  }

  public void register(Fiber fiber, FiberType type, string name)
  {
    synchronized (FiberManager.classinfo)
    {
      if (isRegistered(fiber))
        throw new Exception("Fiber was already registered");

      fibers ~= RegisteredFiber(fiber, type, name);
    }
  }

  public void unRegister(Fiber fiber)
  {
    synchronized (FiberManager.classinfo)
    {
      if (!isRegistered(fiber))
        throw new Exception("Fiber isn't registered");

      size_t prevLength = fibers.length;
      fibers = fibers.remove!(f => f.fiber == fiber);
      assert(fibers.length == prevLength - 1);
    }
  }
}
