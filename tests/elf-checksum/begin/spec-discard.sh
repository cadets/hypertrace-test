#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  self->spec = speculation();
  speculate(self->spec);
  discard(self->spec);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
