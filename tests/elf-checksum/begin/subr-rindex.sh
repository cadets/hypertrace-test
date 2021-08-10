#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(rindex("hello world!", "he"));
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
