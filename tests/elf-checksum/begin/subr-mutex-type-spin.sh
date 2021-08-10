#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(mutex_type_spin((struct mtx *)0));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
