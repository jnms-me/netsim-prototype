#!/usr/bin/env bash
dpp_dpp_files=$(find source/ -name '*_dpp.dpp')
dub run --yes dpp -- --preprocess-only $dpp_dpp_files