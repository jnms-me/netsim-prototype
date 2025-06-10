module socketbuffer;

debug import std.stdio : writeln, writefln;

import std.socket;
import std.algorithm;

/** 
 * Struct for putting response string fragments back together.
 * Taken from the server graph.apiserver module.
 */
struct SocketBuffer
{
  size_t originalSize;
  ubyte[] buffer;
  ubyte[] tempBuffer;
  size_t length = 0;

  @disable this();

  this(size_t size) @safe nothrow
  {
    originalSize = size;
    buffer = new ubyte[](size);
    tempBuffer = new ubyte[](size);
  }

  /** 
   * Add data to the buffer.
   * This also extracts and removes response strings found by adding existing and new data together.
   *
   * Returns: An array of found response strings that may be empty.
   */
  string[] add(in ubyte[] data) @safe
  {
    size_t totalLength = length + data.length;

    if (totalLength < buffer.length)
    {
      size_t newLength = buffer.length;
      while (newLength < totalLength)
      {
        writeln("pre   ", length, " ", totalLength, " ", newLength);
        newLength *= 2;
        if (newLength > 1024 * 1024 * 1024)
        {
          throw new ResponseTooLongException(
            "Server sent more than 1 GB without ending the response message"
          );
        }
        writeln("debug ", length, " ", totalLength, " ", newLength);
      }
      buffer.length = newLength;
      tempBuffer.length = newLength;
    }

    buffer[length .. (length + data.length)] = data[];

    debug (SocketBuffer)
    {
      writeln;
      writefln!"SocketBuffer: adding %d bytes for total length of %d"(data.length, totalLength);
      writefln!"SocketBuffer: current string is: %s"(cast(char[]) buffer[0 .. totalLength]);
    }

    // Search for response delimiters (zero-bytes)
    string[] responseStrings;
    size_t newStartPos = 0;
    for (size_t i = length; i < totalLength; i++)
    {
      ubyte b = buffer[i];
      if (b == 0)
      {
        alias castToString = (ubyte[] arr) @trusted { return cast(string) arr; };

        string fullResponseString = castToString(buffer[newStartPos .. i]); // without trailing zero-byte

        debug (SocketBuffer)
        {
          writefln!"SocketBuffer: found a response string: %s"(cast(char[]) fullResponseString);
        }

        responseStrings ~= fullResponseString[0 .. $].dup;
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

      debug (SocketBuffer)
      {
        writefln!"SocketBuffer: remaining string: %s"(cast(char[]) buffer[0 .. length]);
        writeln;
      }
    }
    else
    {
      length = totalLength;
    }

    return responseStrings;
  }

  void reset() @safe nothrow
  {
    length = 0;
  }
}

class ResponseTooLongException : Exception
{
  this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null) pure nothrow @nogc @safe
  {
    super(msg, file, line, nextInChain);
  }
}
