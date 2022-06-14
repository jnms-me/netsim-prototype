#!/usr/bin/env bash
exit
dpp_d_files=$(find source/ -name '*_dpp.d')
dpp_d_tmp_files=$(find source/ -name '*_dpp.d.tmp')

if [ ! -z "$dpp_d_files" ]; then
  rm $dpp_d_files
fi
if [ ! -z "$dpp_d_tmp_files" ]; then
  rm $dpp_d_tmp_files
fi