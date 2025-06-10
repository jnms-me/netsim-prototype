module netsim.utils.containers;

import std.exception : enforce;
import std.typecons : Nullable;

/** 
 * A queue that can safely be shared between threads.
 * `T` should be shared or immutable.
 */
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

  /** 
   * If the queue is empty, calling pop() doesn't do anything and returns Nullable!T.init (the null state)
   * Returns: a Nullable!T struct
   */
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

  void push(T val) nothrow
  {
    arr ~= val;
  }
}

@("Test SharedQueue")
unittest
{
  import core.thread : Thread;

  shared SharedQueue!int queue = new SharedQueue!int;

  // Single thread
  assert(queue.empty);
  assert(queue.pop == Nullable!(int).init);
  queue.push(1);
  assert(!queue.empty);
  assert(queue.pop.get == 1);
  assert(queue.empty);

  // Multiple threads
  queue.push(2);
  shared bool popped_2 = false;
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

/** 
 * A hashmap that can safely be shared between threads.
 * The key and value types should be non-shared and mutable.
 */
@safe synchronized class SharedMap(Key, Value)
{
  private Value[Key] map;

  this() nothrow
  {
  }

  bool contains(Key key) const nothrow
  {
    return (key in map) !is null;
  }

  /** 
   * If the key isn't present, returns Nullable!T.init (the null state)
   * Returns: a Nullable!T struct
   */
  Nullable!Value opIndex(Key key) const @trusted nothrow
  {
    if (contains(key))
      return Nullable!Value(map[key]);
    else
      return Nullable!Value.init;
  }

  Value opIndexAssign(Value value, Key key) @trusted
  {
    map[key] = value;
    return value;
  }

  bool remove(Key key)
  {
    if (!contains(key))
      return false;
    map.remove(key);
    return true;
  }
}

@("Test SharedMap")
unittest
{
  import core.thread : Thread;

  struct Data
  {
    int a;
  }

  shared SharedMap!(int, Data) map = new SharedMap!(int, Data);

  // Single thread
  assert(!map.contains(1));
  assert(map[1] == Nullable!Data.init);
  map[1] = Data(2);
  assert(map.contains(1));
  assert(map[1] == Nullable!Data(Data(2)));
  map.remove(1);
  assert(!map.contains(1));
  assert(map[1] == Nullable!Data.init);

  // Multiple threads
  map[3] = Data(4);
  Thread thread = new Thread({
    if (map[3] == Nullable!Data(Data(4)))
    {
      map.remove(3);
      map[4] = Data(5);
    }
  });
  thread.start;
  thread.join;
  assert(!map.contains(3));
  assert(map[3] == Nullable!Data.init);
  assert(map.contains(4));
  assert(map[4] == Nullable!Data(Data(5)));
}
