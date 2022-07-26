module netsim.graph.apiserver;

import netsim.core.thread : spawnThread, stopApiServerThread, waitForThreadToExit;
import netsim.graph.graph;
import netsim.utils.containers : SharedQueue;

import std.algorithm : canFind;
import std.concurrency : ownerTid, receive, send, thisTid, Tid;
import std.exception : collectException;
import std.format : format;
import std.stdio : writeln, writefln;
import std.uuid : randomUUID, UUID;

import core.time : msecs;
import core.thread : Thread;

///           ///
// Module init //
///           ///

shared static this()
{
  receivedQueue = new typeof(receivedQueue);
  parsedQueue = new typeof(parsedQueue);
  toSendQueue = new typeof(toSendQueue);
}

///                                 ///
// Entrypoints for apiServer threads //
///                                 ///

/// Main entry point
void apiServerEntryPoint() @trusted nothrow
{
  try
  {
    Thread listenerThread = spawnThread("apiServer listener", &apiServerListenerEntryPoint);
    Thread parserThread = spawnThread("apiServer parser", &apiServerParserEntryPoint);

    UUID uuid = randomUUID;
    writefln!"Sending request with id %s"(uuid);
    receivedQueue.push(ReceivedMessage(randomUUID, "query getProjects()"));

    while (!stopApiServerThread)
    {
      if (!toSendQueue.empty)
      {
        auto msg = toSendQueue.pop.get;
        writefln!"message in toSendQueue as response to %s: %s"(msg.requestId, msg.responseStr);
      }
      Thread.sleep(10.msecs);
    }
    waitForThreadToExit(listenerThread);
    waitForThreadToExit(parserThread);
  }
  catch (Exception e)
  {
    collectException({
      // TODO: log instead
      writeln(e);
    });
  }
}

/// Tcp listener (both receiver and sender) entry point
void apiServerListenerEntryPoint() @trusted nothrow
{
  try
  {
    while (!stopApiServerThread)
    {
      Thread.sleep(10.msecs);
    }
  }
  catch (Exception e)
  {
    collectException({
      // TODO: log instead
      writeln(e);
    });
  }
}

/// Parser entry point
void apiServerParserEntryPoint() @trusted nothrow
{
  auto sleep = { Thread.sleep(1.msecs); };
  try
  {
    while (!stopApiServerThread)
    {
      sleep();
      if (receivedQueue.empty)
        sleep();
      else
      {
        auto front = receivedQueue.pop;
        if (front.isNull)
        {
          // something popped the front between our receivedQueue.empty call and our receivedQueue.pop call
          // Todo: log this
          sleep();
        }
        else
        {
          immutable ReceivedMessage receivedMessage = front.get;

          Request req;

          bool parseError = false;
          string parseErrorMsg;
          try
            req = parseRequest(receivedMessage.requestStr);
          catch (Exception e)
          {
            parseError = true;
            parseErrorMsg = e.msg;
          }

          if (!parseError)
          {
            parsedQueue.push(
              cast(immutable(ParsedMessage)) // unsafe cast needed because Request contains dynamic arrays
              ParsedMessage(receivedMessage.requestId, req)
            );
          }
          else
          {
            // Todo: also log
            toSendQueue.push(MessageToSend(
                receivedMessage.requestId, "error: parsing failed: " ~ parseErrorMsg
            ));
          }
        }
      }
    }
  }
  catch (Exception e)
  {
    collectException({
      // TODO: log instead
      writeln(e);
    });
  }
}

///             ///
// Public Queues //
///             ///

struct ReceivedMessage
{
  UUID requestId;
  string requestStr; /// String without trailing zero-byte
}

/// Received and parsed message.
struct ParsedMessage
{
  UUID requestId;
  Request request;

  this(UUID requestId, Request request) @safe nothrow
  {
    this.requestId = requestId;
    this.request = request;
  }
}

struct MessageToSend
{
  UUID requestId;
  string responseStr; /// String without trailing zero-byte

  /// For sending just the request id (only done by the receiver)
  this(UUID requestId) @safe nothrow
  {
    this.requestId = requestId;
    this.responseStr = requestId.toString;
  }

  /// For sending a message with a leading request id (used by GraphRoot and error handeling)
  this(UUID requestId, string responseStr) @safe nothrow
  {
    this.requestId = requestId;
    this.responseStr = requestId.toString ~ " " ~ responseStr;
  }
}

shared SharedQueue!(immutable(ReceivedMessage)) receivedQueue;
shared SharedQueue!(immutable(ParsedMessage)) parsedQueue;
shared SharedQueue!(immutable(MessageToSend)) toSendQueue;

/+

///
// TCP listener public queues
///

struct ReceivedMessage
{
  UUID requestId;
  string requestStr; /// String without trailing zero-byte
}

struct MessageToSend
{
  UUID requestId;
  string responseStr; /// String without trailing zero-byte

  /// For sending just the request id (only done by the receiver)
  this(UUID requestId) @safe nothrow
  {
    this.requestId = requestId;
    this.responseStr = requestId.toString;
  }

  /// For sending a message with a leading request id (done by graph workers and error handeling)
  this(UUID requestId, string responseStr) @safe nothrow
  {
    this.requestId = requestId;
    this.responseStr = requestId.toString ~ " " ~ responseStr;
  }
}

shared SharedQueue!(immutable(ReceivedMessage)) receivedQueue;
shared SharedQueue!(immutable(MessageToSend)) toSendQueue;

///
// TCP listener callbacks
///

struct ClientInfo
{
  UUID id;
  string address;
  int fd;
}

private shared SharedMap!(TcpClient, ClientInfo) clients; /// Keys are TcpClient objects, values are ClientInfos
private shared SharedMap!(TcpClient, UUID) requestIdClientMap; /// Keys are TcpClient objects, values are request ids

private void onConnected(TcpClient client) @safe nothrow
{
  try
  {
    // TODO: log

    UUID clientId = randomUUID;
    string address = client.safeTcpClientRemoteAddressString;
    int fd = client.safeTcpClientFd;
    // clients.require(client, ClientInfo(clientId, address, fd));
  }
  catch (Exception e)
  {
    // TODO: log
  }
}

private void onDisconnected(const int fd, string address) @safe nothrow
{
  try
  {
    foreach (client, info; clients)
      if (info.fd == fd && info.address == address)
      {
        // TODO: log
        clients.remove(client);
        return;
      }
    throw new Exception("An unknown client disconnected");
  }
  catch (Exception e)
  {
    // TODO: log
  }
}

private void onReceive(TcpClient client, const scope ubyte[] data) @safe nothrow
{
  // Define beforehand so error handling can access it
  UUID clientId;
  UUID requestId;

  bool requestIdWasSent = false;

  try
  {
    assert(data.length >= 0);
    assert(data[$ - 1] == 0);
    assert(clients.contains(client));

    clientId = clients[client].get.id;
    requestId = randomUUID;

    // Send a message back to the client with just the request id
    toSendQueue.push(MessageToSend(
        requestId
    ));
    requestIdWasSent = true;

    string message;
    () @trusted { message = cast(string) data[0 .. $ - 1]; }();

    // Store the received message so a graph worker can process it
    receivedQueue.push(ReceivedMessage(
        requestId, message
    ));
  }
  catch (Exception e)
  {
    collectException({
      // TODO: log
      if (requestIdWasSent)
      {
        // Also send the error to the client
        toSendQueue.push(MessageToSend(
          requestId, "error: " ~ e.msg
        ));
      }
    }());
  }
}

private void onSendCompleted(const int fd, string address, const scope ubyte[] data, const size_t sent_size) nothrow @trusted
{
}

private void onSocketError(const int fd, string address, string err) nothrow @trusted
{
  // TODO: log
}

+/

/+
import vibe.core.core : runEventLoopOnce, yield;
import vibe.core.net : listenTCP, TCPConnection, TCPConnectionDelegate;
import vibe.stream.operations : readUntil;

void handleConnection(TCPConnection conn) nothrow @trusted
{
  // todo: implement request / error quota to fix "nc ip port < /dev/zero" dos attack
  try
  {
    import std.stdio : writeln;

    writeln(thisTid == apiServerTid);

    while (!conn.empty) // blocks until data is received (true) or the connection is closed (false)
    {
      bool parseError = false;
      string parseErrorMsg;

      ubyte[] msg = conn.readUntil([0x00]);

      string reqId = randomUUID.toString;

      conn.write("some request id\x00");

      Request req;
      try
        req = parseRequest(cast(string) msg);
      catch (Exception e)
      {
        parseError = true;
        parseErrorMsg = e.msg;
      }

      if (!parseError)
      {
        netsimThread.send(cast(immutable(Request)) req); // returns instantly
        writeln("api: sent");

        writeln("api: receiving...");
        string res;
        receive((string _res) { // receive response from netsim thread
          writeln("api: received 1");
          res = _res;
        });
        writeln("api: received 2");

        conn.write(cast(ubyte[]) res);
      }
      else
      {
        assert(!parseErrorMsg.canFind("\x00"));
        conn.write(reqId ~ " error: " ~ parseErrorMsg ~ "\x00");
      }
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
+/
