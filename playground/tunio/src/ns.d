module ns;

import std.stdio : File;
import std.conv : to;

extern(C) int setns(int fd, int nstype);

void changeNetNs(int pid)
in(pid > 0)
{
    import std.stdio;
    writeln(pid.to!string);
    auto nsfile = File("/proc/" ~ pid.to!string ~ "/ns/net", "r");
    scope (exit) nsfile.close;
    
    if (setns(nsfile.fileno, 0) == -1)
        throw new Exception("setns failed");
}

void restoreNs()
{

    auto nsfile = File("/proc/1/ns/net", "r");
    scope (exit) nsfile.close;
    
    if (setns(nsfile.fileno, 0) == -1)
        throw new Exception("setns failed");
}
