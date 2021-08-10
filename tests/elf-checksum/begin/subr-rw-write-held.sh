#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(rw_write_held((struct rwlock *)0));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
