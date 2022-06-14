#!/usr/bin/env bash
#./dpp-clean.sh

dpp_dpp_files=$(find source/ -name '*_dpp.dpp')
dub run --yes dpp -- -n --preprocess-only $dpp_dpp_files