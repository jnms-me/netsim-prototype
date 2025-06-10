import std.stdio;
import std.string : toStringz;
import core.sys.posix.sys.ioctl;
import linux_if : ifreq;
import linux_if_tun : IFF_TAP, IFF_NO_PI, TUNSETIFF ;

void main()
{
    auto tap = File("/dev/net/tun", "rw");

    ifreq ifr;
    ifr.ifrn_name = "netsim-tap".toStringz;
    ifr.ifr_flags = IFF_TAP | IFFNO_PI;
    if (ioctl(tap.fileno, TUNSETIFF, &ifreq) == -1)
    {
        throw new Exception("ioctl failed");
    }

    foreach (ubyte[] buffer; tap.byChunk(4))
    {
        writeln("Received: ", buffer);
    }
}
