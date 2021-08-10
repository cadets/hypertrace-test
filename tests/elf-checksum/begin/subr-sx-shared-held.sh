#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(sx_shared_held((struct sx *)NULL));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
