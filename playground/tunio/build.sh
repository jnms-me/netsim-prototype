#!/usr/bin/env bash
cd src
gcc -c *.c
dmd -c *.d
dmd *.o -of=../tunio
rm *.o
