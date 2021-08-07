#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(execname);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
