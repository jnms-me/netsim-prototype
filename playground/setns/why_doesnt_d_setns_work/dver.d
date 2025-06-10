import std.stdio : writeln;
import std.string : toStringz;

import core.sys.posix.fcntl;

extern(C) int setns(int fd, int nstype);

void changeNetNs()
{
    int fd = open("/proc/12135/ns/net".toStringz, O_RDONLY | O_CLOEXEC);

    writeln(fd);

    int result = setns(fd, 0);

    writeln(result);
}

void main()
{
    changeNetNs();
    while(true) {}
}

