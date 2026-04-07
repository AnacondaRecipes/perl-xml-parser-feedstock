#!/bin/bash

set -x

cd "$SRC_DIR"

export PATH=$PREFIX/bin:$PATH

export EXPATLIBPATH="${PREFIX}/lib"
export EXPATINCPATH="${PREFIX}/include"
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

echo "Invoking ${PREFIX}/bin/perl ..."

${PREFIX}/bin/perl Makefile.PL INSTALLDIRS=site
make
make install
