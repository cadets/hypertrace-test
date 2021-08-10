#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(mutex_owner((struct mtx *)0));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
