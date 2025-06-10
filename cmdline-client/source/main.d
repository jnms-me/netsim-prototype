module main;

import socketbuffer;

import std.algorithm : canFind;
import std.concurrency;
import std.conv : to;
import std.exception : collectException, enforce;
import std.format : format;
import std.socket : AddressFamily, InternetAddress, lastSocketError, Socket, SocketOption, SocketOptionLevel, SocketSet, SocketType;
import std.stdio : readln, write, writefln, writeln;
import std.string : join, split, strip;
import std.uuid : UUID;

import gnu.readline : readline;

extern (C) void add_history(char* input);

/// Catches segfaults and prints debug info, only works on x86 and x86_64.
void setupSegfaultHandler() @trusted
{
  import etc.linux.memoryerror;

  static if (is(typeof(registerMemoryErrorHandler)))
    registerMemoryErrorHandler();
}

int main(string[] args) @safe
{
  setupSegfaultHandler;

  enforce(args.length > 0);

  if (args.canFind("-h", "--help", "--usage"))
  {
    printHelp(args[0]);
    return 0;
  }
  else if (args.length != 3)
  {
    writeln("Invalid number of arguments");
    printHelp(args[0]);
    return 1;
  }
  else
  {
    try
    {
      bool shouldReconnect;
      do
      {
        Socket socket = connect(args[1], args[2].to!int);
        shouldReconnect = userPromptLoop(socket);
      }
      while (shouldReconnect);
      return 0;
    }
    catch (Exception e)
    {
      writeln(e.msg);
      return 2;
    }
  }
}

void printHelp(string executable) @safe
{
  writefln!"Usage: %s [host] [port]"(executable);
}

Socket connect(string host, int port) @safe
{
  enforce(0 < port && port <= 65_535, format!"Error: invalid port number %d"(port));
  auto addr = new InternetAddress(host, cast(ushort) port);
  Socket socket = new Socket(AddressFamily.INET, SocketType.STREAM);
  socket.connect(addr);
  writefln!"Connected to %s:%d"(host, port);
  return socket;
}

bool userPromptLoop(Socket socket) @trusted
{

  __gshared Socket _socket;
  _socket = socket;

  enum SocketThreadMessage
  {
    AskReconnect,
    DoneReceiving
  }

  Tid socketThread = spawn(() @trusted nothrow{
    try
    {
      bool askReconnect()
      {
        ownerTid.send(SocketThreadMessage.AskReconnect);
        bool result;
        receive((bool shouldReconnect) { result = shouldReconnect; });
        return result;
      }

      // Buffers for receiving
      ubyte[4096] buffer;
      SocketBuffer socketBuffer = SocketBuffer(1024 * 1024 * 16);

      do // exiting this loop by throw is fatal
      {
        socketBuffer.reset;
        outer: while (true)
        {
          string requestString;
          receive((string req) { requestString = req; });

          if (requestString !is null)
          {
            // Send requestString
            assert(requestString.length > 0); // Should be filtered out when reading user input
            assert(requestString == requestString.strip); // Should be done when reading user input

            requestString ~= "\x00";
            while (requestString.length > 0)
            {
              auto sendResult = _socket.send(requestString);
              if (sendResult == Socket.ERROR)
                throw new Exception(lastSocketError);
              else if (sendResult == 0) // Server disconnected
                break outer;
              else
                requestString = requestString[sendResult .. $];
            }
          }

          // Read messages until we get our requestId and requestId+response messages
          auto readSet = new SocketSet;
          UUID requestId;
          bool gotRequestId, gotResponse;
          while (!(gotRequestId && gotResponse))
          {
            readSet.reset;
            readSet.add(_socket);
            auto selectResult = Socket.select(readSet, null, null);
            if (selectResult == -1) // interruption
            {
            }
            else if (selectResult == 0) // timeout
              assert(false, "Socket.select timed out without specifying a timeout value");
            else // Result is event count
            {
              assert(selectResult == 1);
              auto receiveResult = _socket.receive(buffer[]);
              if (receiveResult == Socket.ERROR)
                throw new Exception(lastSocketError);
              else if (receiveResult == 0) // Server disconnected
                break outer;
              else
              {
                string[] responseStrings = socketBuffer.add(buffer[0 .. receiveResult]);
                foreach (res; responseStrings)
                {
                  writeln(res);
                  auto split = res.split;
                  if (!gotRequestId)
                  {
                    try
                    {
                      requestId = UUID(split[0]);
                      gotRequestId = true;
                      continue;
                    }
                    catch (Exception e)
                    {
                    }
                  }
                  if (split[0] == requestId.toString)
                    gotResponse = true;
                  ownerTid.send(res);
                }
              }
            }
          }
          ownerTid.send(SocketThreadMessage.DoneReceiving);
        }
      }
      while (askReconnect);
    }
    catch (Throwable e)
      collectException(writeln("Socket thread: ", e.msg));
  });

  while (true)
  {
    char* input = readline("> ");
    if (input is null) // Ctrl+D / EOF
      return false;
    add_history(input);

    string requestString = (input.to!string).strip;
    if (requestString.length == 0)
      continue;

    socketThread.send(requestString);

    bool shouldReturn, returnValue;
    bool doneReceiving;
    while (!doneReceiving)
    {
      receive(
        (string res) { writeln(res); },
        (SocketThreadMessage msg) {
        if (msg == SocketThreadMessage.DoneReceiving)
          doneReceiving = true;
        else if (msg == SocketThreadMessage.AskReconnect)
        {
          write("Server disconnected, reconnect? ([y]es/[n]o, enter = yes) ");
          string reconnectAnswer = readln.strip;
          if (reconnectAnswer.length == 0 || reconnectAnswer == "yes" || reconnectAnswer == "y")
            returnValue = true; // Reconnect
          else
            returnValue = false; // Don't reconnect
          shouldReturn = true;
        }
      }
      );
      if (shouldReturn)
        return returnValue;
    }
  }
  assert(false, "Unreachable code");
}

bool isSubscribeUnsubscribeRequest(string req) @safe pure nothrow
{
  import std.format : formattedRead;

  string tmp;
  bool subThrown, unsubThrown;
  try
    req.formattedRead!"subscribe %s"(tmp);
  catch (Exception e)
    subThrown = true;
  try
    req.formattedRead!"unsubscribe %s"(tmp);
  catch (Exception e)
    unsubThrown = true;
  return !(subThrown && unsubThrown);
}

static assert(!isSubscribeUnsubscribeRequest("query foo()"));
static assert(isSubscribeUnsubscribeRequest("subscribe foo()"));
