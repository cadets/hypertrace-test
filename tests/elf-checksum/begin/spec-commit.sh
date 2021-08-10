#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  self->spec = speculation();
  speculate(self->spec);
  commit(self->spec);
}
EOF
        )

$(dirname $0)/../chk-elf ${orig_elf}
