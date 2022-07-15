#!/usr/bin/env rdmd

import std.file;
import std.range;

void main()
{
  auto d_files = dirEntries("source", "*_dpp.d", SpanMode.depth);
  auto tmp_files = dirEntries("source", "*_dpp.d.tmp", SpanMode.depth);
  foreach (DirEntry entry; chain(d_files, tmp_files))
    entry.remove;
}