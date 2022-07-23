module netsim.utils.sharedqueue;

import std.exception : enforce;
import std.typecons : Nullable;

@safe synchronized class SharedQueue(T)
{
  private T[] arr;

  this() nothrow
  {
  }

  bool empty() const nothrow
  {
    return arr.length == 0;
  }

  /// If the queue is empty, calling pop() doesn't do anything and returns Nullable!T.init (the null state)
  Nullable!T pop() nothrow
  {
    if (!empty)
    {
      T t = arr[0];
      arr = arr[1 .. $];
      return Nullable!T(t);
    }
    else
      return Nullable!T.init;
  }

  void push(T t) nothrow
  {
    arr ~= t;
  }
}

@("Test SharedQueue")
unittest
{
  import core.thread : Thread, thread_joinAll;

  shared SharedQueue!int queue = new SharedQueue!int;

  // Single thread
  assert(queue.empty);
  assert(queue.pop == Nullable!int.init);
  queue.push(1);
  assert(!queue.empty);
  assert(queue.pop.get == 1);
  assert(queue.empty);

  // Multiple threads
  queue.push(2);
  __gshared bool popped_2 = false;
  Thread thread = new Thread({
    if (queue.pop.get == 2)
      popped_2 = true;
    queue.push(3);
  });
  thread.start;
  thread.join;
  assert(popped_2);
  assert(queue.pop.get == 3);
}
