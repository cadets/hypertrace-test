(mk-hypertrace-stager
 '((name "ELF Checksum Tests")
   (directory-path "./elf-checksum/")
   (binary-dependencies ("/bin/sh"
                         "dtrace"
                         "sha256sum"))))
