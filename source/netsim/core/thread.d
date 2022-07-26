module netsim.core.thread;

import netsim.core.graphroot : graphThreadEntryPoint;
import netsim.graph.apiserver : apiServerEntryPoint;

import std.stdio : writefln, writeln;
import std.string : toStringz;

import netsim.utils.prctl_dpp : PR_SET_NAME, prctl;

import core.stdc.signal : SIGINT, signal, SIGTERM;
import core.thread : Thread;
import core.time : Duration, msecs;

private
{
  Thread graphThread;
  Thread apiServerThread;
}

__gshared
{
  bool stopMainThread = false;

  bool stopGraphThread = false;
  bool stopApiServerThread = false;
}

///               ///
// Signal handling //
///               ///

extern (C) void onSignal(int sig) @system nothrow @nogc
{
  stopMainThread = true;
}

/// Should be called from the main thread.
void registerSignalHandlers() @trusted nothrow @nogc
{
  signal(SIGINT, &onSignal);
  signal(SIGTERM, &onSignal);
}

///               ///
// Thread spawning //
///               ///

void setThreadName(string name)
{
  Thread.getThis.name = name;
  prctl(PR_SET_NAME, name.toStringz);
}

void printThreadId(string name)
{
  writefln!"%s thread id: %u"(name, Thread.getThis.id);
}

Thread spawnThread(string name, void function() @safe nothrow entryPoint) @trusted nothrow
{
  Thread thread = new Thread(() @trusted {
    try
    {
      setThreadName(name);
      printThreadId(name); // Todo: replace with log
      entryPoint();
      writefln!"exiting %s thread"(name); // Todo: replace with log
    }
    catch (Error e)
    {
      writefln!"%s thread crashed"(name); // Todo: replace with log
      writeln(e);
    }
  });
  thread.start;
  return thread;
}

void spawnThreads()
{
  graphThread = spawnThread("graph", &graphThreadEntryPoint);
  apiServerThread = spawnThread("apiServer", &apiServerEntryPoint);
}

///               ///
// Thread shutdown //
///               ///

void waitForThreadToExit(ref Thread thread) @trusted nothrow
{
  while (thread.isRunning)
    Thread.sleep(1.msecs);
}

/// Should be called from the main thread when stopMainThread becomes true.
void shutdownApplication() @trusted nothrow
{
  stopGraphThread = true;
  waitForThreadToExit(graphThread);
  stopApiServerThread = true;
  waitForThreadToExit(apiServerThread);
}
