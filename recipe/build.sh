#!/bin/bash

set -x

cd "$SRC_DIR"

export PATH=$PREFIX/bin:$PATH

echo "Invoking ${PREFIX}/bin/perl ..."

${PREFIX}/bin/perl Makefile.PL EXPATLIBPATH=${PREFIX}/lib EXPATINCPATH=${PREFIX}/include INSTALLDIRS=site
make
make install
