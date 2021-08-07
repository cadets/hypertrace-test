#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  this->x = 0xDEADBEEF;
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
