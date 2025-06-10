/// The async library has some small problems, this module has workarounds for those problems.
module netsim.utils.asyncfixes;
/+

import async.net.tcpclient : TcpClient;

/// remoteAddress isn't marked @safe even though it is
string safeTcpClientRemoteAddressString(TcpClient client) @trusted
{
  return client.remoteAddress.toString;
}

/// fd isn't marked @safe even though it is
int safeTcpClientFd(TcpClient client) @trusted
{
  return client.fd;
}
+/