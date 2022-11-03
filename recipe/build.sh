#!/bin/bash

echo "adding cc/cxx symlinks ${CC} / ${CXX}"
ln -s ${CXX} ./g++
ln -s ${CC} ./gcc

export PATH=$PWD:$PATH

echo "Invoking ${PREFIX}/bin/perl ..."
ls -la ${PREFIX}/bin

${PREFIX}/bin/perl Makefile.PL EXPATLIBPATH=${PREFIX}/lib EXPATINCPATH=${PREFIX}/include INSTALLDIRS=site
make
make install
