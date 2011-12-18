#!/usr/bin/env python

import sys

try:
  byte = int(sys.argv[1],base=16)
  files = sys.argv[2:]
  assert len (files) >= 1
except:
  print "Usage:"
  print "    countbyte.py <hex_byte_val> <file> [files..]" 

val = chr(byte)
for f in files:
  print "%40s" % f,
  print len ([ c for c in open(f).read() if c == val])



