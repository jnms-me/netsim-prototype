#!/usr/bin/env rdmd

import std.file;
import std.string;
import std.process;

string[] fileList()
{
  string[] list;
  foreach (DirEntry dpp_dpp_entry; dirEntries("source", "*_dpp.dpp", SpanMode.depth))
  {
    string dpp_d_name = dpp_dpp_entry.name[0 .. $ - 4] ~ ".d";
    if (exists(dpp_d_name))
    {
      DirEntry dpp_d_entry = DirEntry(dpp_d_name);
      // if newer than source, skip
      if (dpp_d_entry.timeLastModified > dpp_dpp_entry.timeLastModified)
        continue;
    }
    list ~= dpp_dpp_entry.name;
  }
  return list;
}

void main()
{
  auto list = fileList;
  if (!list.empty)
  {
    executeShell("dub run --yes dpp -- -n --preprocess-only " ~ list.join(" "));
  }
}
