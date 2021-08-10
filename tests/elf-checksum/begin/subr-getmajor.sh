#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(getmajor((dev_t)NULL));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
