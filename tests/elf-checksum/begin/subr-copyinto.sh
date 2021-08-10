#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  copyinto(0, 4, NULL);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
