#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(ntohll(4));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
