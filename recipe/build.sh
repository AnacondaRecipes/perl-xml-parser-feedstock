#!/bin/bash

set -exou

if [[ $(uname) == "Linux" ]]; then
    echo "adding gcc/gxx symlinks"
    ln -s ${GXX} ./g++
    ln -s ${GCC} ./gcc

    export PATH=$PWD:$PATH
fi

$PREFIX/bin/perl Makefile.PL EXPATLIBPATH=${PREFIX}/lib EXPATINCPATH=${PREFIX}/include INSTALLDIRS=site
make
make install
