#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  @ = lquantize(1, 0, 100, 10);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
