#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  x = 0xFEEDFACE;
  self->x = 0xDEADBEEF;
  this->x = 0xCAFEBEEF;
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
