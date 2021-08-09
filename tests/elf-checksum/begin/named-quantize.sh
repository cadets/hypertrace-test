#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  @quantize = quantize(1);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
