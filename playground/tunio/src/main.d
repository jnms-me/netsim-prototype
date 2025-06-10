module main;

import std.stdio;
import std.conv : to;
import ns, opentap;

import core.sys.posix.unistd;
import core.thread.osthread : getpid;

int main(string[] args)
{
    if (args.length < 2)
    {
        if (args.length >= 1)
            writeln("Usage: " ~ args[0] ~ " [pid]");
        return 1;
    }

    changeNetNs(args[1].to!int);

    File tap = openTap("netsim-tap");

    restoreNs();

    writeln(tap);
    writeln(tap.fileno);

    ubyte[65536] buffer;
    while(true)
    {
        long result = read(tap.fileno, cast(void*) &buffer, buffer.sizeof);
        if (result > 0)
            writeln("Received", buffer[0 .. result]);
        //writeln(tap.rawRead(buffer[]));
    }
    return 0;
}

