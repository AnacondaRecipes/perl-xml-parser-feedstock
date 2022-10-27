#!/bin/bash

ln -s ${CC} ./gcc
export PATH=$PWD:$PATH
CC=gcc

perl Makefile.PL EXPATLIBPATH=$PREFIX/lib EXPATINCPATH=$PREFIX/include INSTALLDIRS=site
make
make install
