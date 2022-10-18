#!/usr/bin/env python

import sys
import gzip

i = 0

with gzip.open(sys.argv[1], "rt") as in_f:
    for line in in_f:
        if i%4 == 0:
            print(line.strip()[1:])
        i += 1
