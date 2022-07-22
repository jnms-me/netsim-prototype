module netsim.main;

import netsim.core.netsim;

import std.stdio;

import core.thread : Thread;
import core.time : Duration;

void main()
{
  Netsim netsim = new Netsim;

  while (true)
  {
    Thread.sleep(Duration.max);
  }
}