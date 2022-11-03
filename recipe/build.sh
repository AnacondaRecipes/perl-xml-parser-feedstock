#!/bin/bash

ln -s ${CC} ./gcc
export PATH=$PWD:$PATH
CC=gcc

$PREFIX/bin/perl Makefile.PL EXPATLIBPATH=${PREFIX}/lib EXPATINCPATH=${PREFIX}/include INSTALLDIRS=site
make
make install
