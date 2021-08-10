#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(mutex_owned((struct mtx *)0));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
