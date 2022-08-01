module netsim.graph.apiserver;

import netsim.core.thread : spawnThread, stopApiServerThread, waitForThreadToExit;
import netsim.graph.graph;
import netsim.utils.containers : SharedQueue;

import std.algorithm : canFind;
import std.concurrency : ownerTid, receive, send, thisTid, Tid;
import std.exception : collectException;
import std.format : format;
import std.socket : AddressFamily, InternetAddress, lastSocketError, Socket, SocketOption, SocketOptionLevel, SocketSet,
  SocketType;
import std.stdio : writefln, writeln;
import std.uuid : randomUUID, UUID;

import core.time : msecs;
import core.thread : Thread;

//             //
// Module init //
//             //

shared static this()
{
  receivedQueue = new typeof(receivedQueue);
  parsedQueue = new typeof(parsedQueue);
  toSendQueue = new typeof(toSendQueue);
}

//                                   //
// Entrypoints for apiServer threads //
//                                   //

/// Main entry point
void apiServerEntryPoint() @trusted nothrow
{
  try
  {
    Thread listenerThread = spawnThread("apiServer listener", &apiServerListenerEntryPoint);
    Thread parserThread = spawnThread("apiServer parser", &apiServerParserEntryPoint);

    while (!stopApiServerThread)
    {
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
    // std.socket guide: https://dpldocs.info/this-week-in-d/Blog.Posted_2019_11_11.html#sockets-tutorial

    Socket listener = new Socket(AddressFamily.INET, SocketType.STREAM);
    listener.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);

    listener.bind(new InternetAddress("localhost", 9005));
    listener.listen(10);

    SocketSet readSet = new SocketSet;

    Socket[] connectedClients;

    SocketBuffer[Socket] socketBuffers;
    // UUID[UUID][Socket] socketRequestIdsMap;
    Socket[UUID] requestIdSocketMap;

    while (!stopApiServerThread)
    {
      //
      // Handle connect/disconnect and receive data
      //
      readSet.reset();
      foreach (client; connectedClients)
        readSet.add(client);
      readSet.add(listener);

      int eventCount = Socket.select(readSet, null, null, 1.msecs);

      if (eventCount == -1) // interruption
      {
      }
      else if (eventCount == 0) // timeout
      {
      }
      else if (eventCount > 0)
      {
        // Check listener
        if (readSet.isSet(listener)) // A new client wants to connect
        {
          auto newSocket = listener.accept;
          connectedClients ~= newSocket;
          socketBuffers[newSocket] = SocketBuffer(1024 * 16);
          // socketRequestIdsMap[newSocket] = null; // set the UUID[UUID] aa to its init state (null)
          eventCount--;
        }

        for (int i = 0; i < connectedClients.length; i++)
        {
          if (eventCount == 0)
            break; // break inner for loop

          Socket client = connectedClients[i];
          if (readSet.isSet(client)) // Client has data available for reading or has disconnected
          {
            eventCount--;

            ubyte[4096] buffer;
            auto readCount = client.receive(buffer[]);
            if (readCount == Socket.ERROR)
            {
              throw new Exception(lastSocketError);
            }
            else if (readCount == 0) // Client disconnected
            {
              client.close;
              // onDisconnected
              connectedClients[i] = connectedClients[$ - 1];
              connectedClients = connectedClients[0 .. $ - 1];
              socketBuffers.remove(client);
              // socketRequestIdsMap.remove(client);
              foreach (id, socket; requestIdSocketMap)
                if (socket == client)
                  requestIdSocketMap.remove(id); // the foreach seems to handle removing while iterating fine
              i--;
            }
            else // The client sent data
            {
              assert((client in socketBuffers) !is null);
              ubyte[] data = buffer[0 .. readCount];
              string[] requestStrings = socketBuffers[client].add(data);

              foreach (requestStr; requestStrings)
              {
                UUID requestId = randomUUID;
                assert((requestId in requestIdSocketMap) is null);
                requestIdSocketMap[requestId] = client;
                receivedQueue.push(ReceivedMessage(
                    requestId, requestStr
                ));
                toSendQueue.push(MessageToSend(
                    requestId
                ));
              }
            }
          }
        }
      }
      else
        assert(false, format!"Socket.select returned invalid value %d"(eventCount));

      //
      // Send data
      //
      if (!toSendQueue.empty)
      {
        auto front = toSendQueue.pop;
        if (front.isNull)
        {
          // something popped the front between our toSendQueue.empty call and our toSendQueue.pop call
          // Todo: log this
        }
        else
        {
          immutable MessageToSend messageToSend = front.get;
          if ((messageToSend.requestId in requestIdSocketMap) is null)
          {
            // Unknown request id, client has disconnected while the request was processing
          }
          else
          {
            Socket client = requestIdSocketMap[messageToSend.requestId];
            string message = messageToSend.responseStr ~ "\x00";
            while (message.length)
            {
              auto sendResult = client.send(message[]);
              if (sendResult == Socket.ERROR)
              {
                // Todo: handle error somehow
                throw new Exception(format!"client socket send error: %s"(lastSocketError));
              }
              else if (sendResult == 0)
              {
                // Todo: handle disconnect
                throw new Exception("client disconnected during send()");
              }
              else
              {
                message = message[sendResult .. $];
              }
            }
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

/// Parser entry point
void apiServerParserEntryPoint() @trusted nothrow
{
  alias sleep = () => Thread.sleep(1.msecs);
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
              cast(immutable(ParsedMessage)) // unsafe cast needed because Request contains dynamic arrays i think
              ParsedMessage(receivedMessage.requestId, req)
            );
          }
          else
          {
            // Todo: also log
            toSendQueue.push(MessageToSend(
                receivedMessage.requestId, parseErrorMsg
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

//               //
// Public Queues //
//               //

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

//              //
// SocketBuffer //
//              //

/// Struct for putting request string fragments back together
struct SocketBuffer
{
  ubyte[] buffer;
  ubyte[] tempBuffer;
  size_t length = 0;

  @disable this();

  this(size_t size)
  {
    buffer = new ubyte[](size);
    tempBuffer = new ubyte[](size);
  }

  /** 
   * Add data to the buffer.
   * This also extracts and removes request strings found by adding existing and new data together.
   *
   * Returns: An array of found request strings that may be empty.
   */
  string[] add(in ubyte[] data) @trusted //@safe nothrow
  {
    size_t totalLength = length + data.length;

    if (totalLength < buffer.length)
    {
      reset;
      // Todo: log "SocketBuffer length would be over %d bytes, SocketBuffer has been reset"
    }

    buffer[length .. (length + data.length)] = data[];

    // writefln!"SocketBuffer: adding %d bytes for total length of %d"(data.length, totalLength);
    // writefln!"SocketBuffer: current string is: %s"(cast(char[]) buffer[0 .. totalLength]);

    // Search for request delimiters (zero-bytes)
    string[] requestStrings;
    size_t newStartPos = 0;
    for (size_t i = length; i < totalLength; i++)
    {
      ubyte b = buffer[i];
      if (b == 0)
      {
        alias castToString = (ubyte[] arr) @trusted { return cast(string) arr; };

        string fullRequestString = castToString(buffer[newStartPos .. i]); // without trailing zero-byte

        // writefln!"SocketBuffer: found a request string: %s"(cast(char[]) fullRequestString);

        requestStrings ~= fullRequestString[0 .. $].dup;
        newStartPos = i + 1;
      }
    }

    // Apply the new start position
    if (newStartPos > 0)
    {
      size_t lengthAfterCutting = totalLength - newStartPos;
      tempBuffer[0 .. lengthAfterCutting] = buffer[newStartPos .. totalLength];
      buffer[0 .. lengthAfterCutting] = tempBuffer[0 .. lengthAfterCutting];
      length = lengthAfterCutting;

      // writefln!"SocketBuffer: remaining string: %s"(cast(char[]) buffer[0 .. length]);
      // writeln;
    }
    else
    {
      length = totalLength;
    }

    return requestStrings;
  }

  void reset() @safe nothrow
  {
    length = 0;
  }
}
