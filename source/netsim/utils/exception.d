module netsim.utils.exception;

import std.format : format;

import core.stdc.errno : errno;
import core.stdc.string : strerror;

string errnoInfo()
{
  return format!"errno %d and strerror %s"(errno, strerror(errno));
}
