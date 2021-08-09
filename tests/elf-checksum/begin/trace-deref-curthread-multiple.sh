#!/bin/sh

# DEPENDS ON: FreeBSD

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(curthread->td_proc->p_ucred->cr_uid);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
