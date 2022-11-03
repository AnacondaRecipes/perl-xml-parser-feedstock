#!/bin/bash
i
if [[ $(uname) == "Linux" ]]; then
    ln -s ${CXX} g++ || true
    ln -s ${CC} gcc || true

    export LD=${GXX}
    export CC=${GCC}
    export CXX=${GXX}

    export PATH=$PWD:$PATH
fi

$PREFIX/bin/perl Makefile.PL EXPATLIBPATH=${PREFIX}/lib EXPATINCPATH=${PREFIX}/include INSTALLDIRS=site
make
make install
