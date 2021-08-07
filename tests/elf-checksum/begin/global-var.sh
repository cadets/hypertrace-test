#!/bin/sh

orig_elf=$(dtrace -q -E -e -s /dev/stdin <<EOF
BEGIN {
  x = 0xDEADBEEF;
}
EOF
        )

if [ -z ${orig_elf} ]
then
    echo "Error creating the initial ELF file."
    exit 1
fi

new_elf=$(dtrace -q -e -y ${orig_elf})

if [ -z ${new_elf} ]
then
    echo "Error creating the second ELF file (original is ${orig_elf})"
    exit 1
fi

orig_sha=$(sha256sum -q ${orig_elf})
new_sha=$(sha256sum -q ${new_elf})

if test ${orig_sha} = ${new_sha}
then
    exit 0
else
    echo "Checksum mismatch of ${orig_elf} and ${new_elf}"
    exit 1
fi
