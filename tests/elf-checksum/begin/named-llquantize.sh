#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  @llquantize = llquantize(1, 2, 0, 8, 2);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
