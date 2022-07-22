module netsim.main;

import netsim.core.netsim;

import std.stdio;

void main()
{
  Netsim netsim = new Netsim;
  netsim.listenForGraphApiRequests;
}