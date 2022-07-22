module netsim.graph.apiserver;

import netsim.graph.graph;

import std.concurrency : Tid, ownerTid, send;
import std.stdio : writeln;

import vibe.core.core : runEventLoopOnce;
import vibe.core.net : listenTCP, TCPConnection, TCPConnectionDelegate;
import vibe.stream.operations : readUntil;

void graphApiServerLoop()
{
  // todo: replace assert with log and enclose in while loop
  GraphApiServer apiServer = new GraphApiServer(ownerTid);
  apiServer.start;
  assert(false, "The api server has stopped");
}

class GraphApiServer
{
  private Tid parentThread;

  this(Tid parentThread)
  {
    this.parentThread = parentThread;
  }

  void start()
  {
    auto listener = listenTCP(9005, &handleConnection, "127.0.0.1");
    while (true)
    {
      runEventLoopOnce;
    }
  }

  void handleConnection(TCPConnection conn) nothrow @trusted
  {
    try
    {
      while (!conn.empty) // blocks until data is received (true) or the connection is closed (false)
      {
        ubyte[] msg = conn.readUntil([0x00]);
        handleRequestString(cast(string) msg);
      }
      writeln("connection closed");
    }
    catch (Exception e)
    {
      try
      {
        writeln(e);
      }
      catch (Exception e)
      {
      }
    }
  }

  void handleRequestString(string reqStr) nothrow
  {
    try
    {
      writeln(reqStr);
      Request req = parseRequest(reqStr);
      writeln(req);
      // parse
      // send to parentThread

      // receive response
    }
    catch (Exception e)
    {
      try
      {
        writeln("Error: ", e.msg);
      }
      catch (Exception e)
      {
      }
    }
  }
}
