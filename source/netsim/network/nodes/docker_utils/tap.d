module netsim.network.nodes.docker_utils.tap;

import netsim.network.nodes.docker_utils.tap_dpp;
import netsim.utils.exception;

import std.exception : enforce, ErrnoException;
import std.format : format;
import std.process : execute;
import std.stdio : File;
import std.string : toStringz;

enum IFNAME_MAXSIZE = IFNAMSIZ - 1;

void createTap(string ifname)
in (ifname.length <= IFNAME_MAXSIZE)
{
  auto result = execute([
    "ip", "tuntap", "add", ifname, "mode", "tap", "user", "root"
  ]);
  enforce(result.status == 0,
    format!"ip tuntap add returned non-zero status code %d with output '%s'"(
      result.status,
      result.output
  ));
}

File openTap(string ifname)
in (ifname !is null)
in (ifname.length <= IFNAME_MAXSIZE)
{
  enforce(ifname.length <= IFNAME_MAXSIZE,
    format!"openTap failed: ifname is too long (limit: %d)"(IFNAME_MAXSIZE)
  );

  // Build config struct
  ifreq ifr;
  // Copy name string, converting it to a zero-terminated string
  ifr.ifr_ifrn.ifrn_name[] = 0;
  ifr.ifr_ifrn.ifrn_name[0 .. ifname.length] = ifname[];
  ifr.ifr_ifru.ifru_flags = IFF_TAP | IFF_NO_PI;

  // Open file descriptor
  int fd;
  if ((fd = open("/dev/net/tun".toStringz, O_RDWR)) == -1)
    throw new Exception(format!"openTap failed: open /dev/net/tun failed with %s"(errnoInfo));

  scope (failure)
    close(fd);

  // Send config struct
  if (ioctl(fd, TUNSETIFF, &ifr) == -1)
    throw new Exception(format!"openTap failed: ioctl /dev/net/tun failed with %s"(errnoInfo));

  // Set non-blocking flag
  int flags;
  if ((flags = fcntl(fd, F_GETFL, 0)) == -1)
    throw new Exception(format!"openTap failed: getting flags failed with %s"(errnoInfo));

  if (fcntl(fd, F_SETFL, flags | O_NONBLOCK) == -1)
    throw new Exception(
      format!"openTap failed: setting non-blocking flag failed with %s"(errnoInfo));

  enforce(fd >= 0, "openTap failed: unknown error");

  // Pack fd into a File
  File file;
  try
    file.fdopen(fd, "rw");
  catch (ErrnoException)
    throw new Exception(format!"openTap failed: packing fd into a File failed with %s"(errnoInfo));

  return file;
}
