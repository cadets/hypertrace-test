# HyperTrace Test Framework/Suite

This repository contains both the necessary framework and the entire test suite
used for testing the CADETS HyperTrace implementation. The current state of the
code is heavily unstable and changing often. Tests themselves can be specified
in the `tests/` subdirectory. Each subdirectory of `tests/`, for example
`tests/example` needs to have a test stager specified under `stagers/`. See
`stagers/example.scm`. In the future, it is likely that stagers will be able
to stage multiple directories, however that is not supported quite yet, as it
is unclear what they would be filtered on.

## TODO

* Custom diffing functions (e.g. allowing different ordering, not exact match).
* FreeBSD port.


# Build/Install guide

## Chicken Scheme

This project is implemented in [Chicken Scheme](http://www.call-cc.org/), which
is a BSD-licensed Scheme implementation. It supports both compilation to C (and
through that, individual binaries) and can be interpreted using `csi`. This
project is mostly meant to be compiled down to a single binary (and perhaps in
the future as a library). Chicken Scheme can easily be called from C, and it can
easily call C.

## Building from Source

### FreeBSD

```
# pkg install chicken5 gmake
./bootstrap
gmake
```

### GNU/Linux distributions

```
# <package manager> install chicken
./bootstrap
make
```

### Building Chicken from source

A download to a [Chicken Scheme tarball](http://code.call-cc.org/) is available
on their website on the Downloads page. Download the tarball, verify the
checksum using `sha256sum` and simply issue:

```
make PLATFORM=(bsd|linux|macosx)
sudo make PLATFORM=(bsd|linux|macosx) install
```

This will get you the necessary binaries and the `libchicken` library which is
the only runtime dependency of the HyperTrace test suite.

You will then be able to run the generic build instructions of

```
./bootstrap
gmake
```

which will use `chicken-install` to set up the necessary build dependencies and
`csc` to build the source into a single binary which depends on `libchicken`.
You can check that everything was correctly linked using `ldd` (sample FreeBSD
output):

```
ldd build/hypertrace-test 
build/hypertrace-test:
        libchicken5.so.11 => /usr/local/lib/libchicken5.so.11 (0x800252000)
        libm.so.5 => /lib/libm.so.5 (0x800630000)
        libthr.so.3 => /lib/libthr.so.3 (0x800667000)
        libc.so.7 => /lib/libc.so.7 (0x800694000)
```

# Running the test suite

Currently, there are no actual HyperTrace tests in the HyperTrace Test Suite.
Still, there are a couple of tests for testing the test suite itself. You can
run them by simply running `./build/bin/hypertrace-test` from the checkout root
directory.

Further, there is a `HYPERTRACE_TESTPATH` environment variable that the
HyperTrace test suite recognises. If it is set, the tests and stagers will be
looked for in that directory.