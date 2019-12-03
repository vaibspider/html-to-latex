#!/bin/bash

if [ $# -lt 2 ];then
  echo "Usage: $0 <input-HTML-file> <output-LaTeX-file>"
  exit 1
fi
make
./parser $2 < $1
