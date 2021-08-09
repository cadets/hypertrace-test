#!/bin/sh

# DEPENDS ON: FreeBSD

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(curthread->td_tid);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
