#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
struct {
  int x;
} x[10];

BEGIN {
  trace(x[0].x);
  trace(x[1].x);
  trace(x[2].x);
  trace(x[3].x);
  trace(x[4].x);
  trace(x[5].x);
  trace(x[6].x);
  trace(x[7].x);
  trace(x[8].x);
  trace(x[9].x);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
