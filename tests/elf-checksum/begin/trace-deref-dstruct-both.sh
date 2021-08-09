#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
struct {
  int x;
} x, *_x;

BEGIN {
  trace(x.x);
  trace(_x->x);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
