#!/bin/bash

set -x

cd "$SRC_DIR"

export PATH="${PREFIX}/bin:${PATH}"

export EXPATLIBPATH="${PREFIX}/lib"
export EXPATINCPATH="${PREFIX}/include"
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

# Link via the compiler driver: LDFLAGS contain -Wl,* which plain ld does not accept.
export LD="${CC}"
export PERL_MM_OPT="CC=${CC} LD=${CC}"

${PREFIX}/bin/perl Makefile.PL INSTALLDIRS=site

make
make install
