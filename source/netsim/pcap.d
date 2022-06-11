module netsim.pcap;

import std.datetime.systime;
import std.datetime.timezone : UTC;

import std.stdio;

/** 
 * See https://wiki.wireshark.org/Development/LibpcapFileFormat
 */
struct Pcap
{
  struct GlobalHeader
  {
    uint magic_number = 0xa1b2c3d4;
    ushort version_major = 2;
    ushort version_minor = 4;
    int thiszone = 0;
    uint sigfigs = 0;
    uint snaplen = 65_535; // Max record length
    uint network = 1; // 1 For Ethernet

    ubyte[] serialize()
    {
      ubyte* ptr = cast(ubyte*)&this;
      size_t len = this.sizeof;
      return ptr[0 .. len];
    }
  }

  struct RecordHeader
  {
    uint ts_sec;
    uint ts_usec;
    uint incl_len;
    uint orig_len;

    ubyte[] serialize()
    {
      ubyte* ptr = cast(ubyte*)&this;
      size_t len = this.sizeof;
      return ptr[0 .. len];
    }
  }
}

class PcapStream
{
  /** 
   * Params:
   *   maxRecordLengh = The max length of captured records, in octets.
   */
  public this(uint maxRecordLength = 65_535)
  {
    Pcap.GlobalHeader header;
    header.snaplen = maxRecordLength;
    send(header.serialize());
  }

  public void addRecord(ubyte[] data, SysTime ts = Clock.currTime(UTC()))
  {
    Pcap.RecordHeader header;

    // This cast will overflow in 2106
    header.ts_sec = cast(uint) ts.toUnixTime();
    const auto fracSecs = ts.fracSecs.split;
    header.ts_usec = 1000 * cast(uint) fracSecs.msecs + cast(uint) fracSecs.usecs;

    header.incl_len = cast(uint) data.length;
    header.orig_len = cast(uint) data.length;

    send(header.serialize() ~ data);
  }

  private void send(ubyte[] data)
  {
    write(cast(char[]) data);
    stdout.flush();
  }
}