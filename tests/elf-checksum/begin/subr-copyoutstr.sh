#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  copyoutstr("hello world", 0, 12);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
