#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
#pragma D option aggsize=16m
BEGIN {}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
