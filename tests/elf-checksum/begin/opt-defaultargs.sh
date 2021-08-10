#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
#pragma D option defaultargs
BEGIN {}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
