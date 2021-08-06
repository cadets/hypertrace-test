#!/bin/sh

DTRACE=$(which dtrace)
SHA256SUM=$(which sha256sum)
DIFF=$(which diff)

if [ -z ${DTRACE} ] || [ -z ${SHA256SUM} ] || [ -z ${DIFF} ]
then
    exit 1
fi

orig_elf=$(${DTRACE} -q -E -e -s /dev/stdin <<EOF
BEGIN {
  trace(0);
}
EOF
        )

if [ -z ${orig_elf} ]
then
    echo "Error creating the initial ELF file."
    exit 1
fi

new_elf=$(${DTRACE} -q -e -y ${orig_elf})

if [ -z ${new_elf} ]
then
    echo "Error creating the second ELF file (original is ${orig_elf})"
    exit 1
fi

orig_sha=$(${SHA256SUM} -q ${orig_elf})
new_sha=$(${SHA256SUM} -q ${new_elf})

if test ${orig_sha} = ${new_sha}
then
    exit 0
else
    echo "Checksum mismatch of ${orig_elf} and ${new_elf}"
    exit 1
fi
