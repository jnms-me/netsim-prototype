module opentap;

import std.string : toStringz;
import std.stdio : File;
import std.format : format;

extern(C) extern __gshared const int OPENTAP_C_IFNAME_MAXSIZE;
extern(C) int opentap_c(const(char)* ifname);

File openTap(string ifname)
in(ifname !is null)
in(ifname.length <= OPENTAP_C_IFNAME_MAXSIZE)
{
    int fd = opentap_c(ifname.toStringz);

    switch(fd)
    {
        case -3:
            throw new Exception(format!"opentap_c failed: ifname is too long (limit: %d)"(OPENTAP_C_IFNAME_MAXSIZE));
        case -2:
            throw new Exception("opentap_c failed: open failed");
        case -1:
            throw new Exception("opentap_c failed: ioctl failed");
        default:
            assert(fd >= 0);
            break;
    }

    File file;
    file.fdopen(fd, "rw");
    return file;
}
