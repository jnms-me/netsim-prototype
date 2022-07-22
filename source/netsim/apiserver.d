module netsim.apiserver;

import netsim.graph;

import vibe.core.core : runEventLoopOnce;
import vibe.core.net : listenTCP, TCPConnection, TCPConnectionDelegate;
import vibe.stream.operations : readUntil;

import std.stdio : writeln;

class GraphApiServer
{
  private GraphNode root;

  this(GraphNode root)
  {
    this.root = root;
  }

  void start()
  {
    TCPConnectionDelegate dg = (TCPConnection conn) nothrow @trusted {
      try
      {
        while (!conn.empty)
        {
          ubyte[] msg = conn.readUntil([0x00]);
          writeln(cast(char[]) msg);
        }
        writeln("connection closed");
      }
      catch (Exception e)
      {
        try
          writeln(e);
        catch (Exception e)
        {
        }
      }
    };

    auto listener = listenTCP(9005, dg, "127.0.0.1");
    while (true)
    {
      runEventLoopOnce;
    }
  }

  void handleIncoming(string reqStr)
  {
    handleRequest(reqStr, root);
  }
}
