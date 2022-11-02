#!/bin/bash
cd ${SRC_DIR}
ls -al

# Update Perls CC path
perl -V:cc #Prints old CC path
perl -i~ -spe's{^\s*cc\s*=>\s*\x27\K[^\x27]*}{$cc}' \
   -- -cc=${CC} \
   -- "$( perldoc -lm Config )"
perl -V:cc #Prints new CC path

## Attempt to set perl include paths
# export CXXFLAGS="${CXXFLAGS} -i$PREFIX/include -L$PREFIX/lib"
# export CFLAGS="${CXXFLAGS} -i$PREFIX/include -L$PREFIX/lib"
# export PERLLIB=$PERLLIB:$PREFIX/lib
# export PERL5LIB=$PERL5LIB:$PREFIX/lib

## Try manually building expat
# cd Expat
# perl Makefile.PL
# make
# make install
# cd ..

## Set LD_LIBRARY_PATH as recommended by Expat output
# export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
# export LIBRARY_PATH="$PREFIX/lib:$LIBRARY_PATH"


echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!LIB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
ls -al $PREFIX/lib 
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!INCLUDE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
ls -al $PREFIX/include
# cat $PREFIX/include/expat_config.h 
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"


perl -V:libs
perl -V:so
perl -V:libpth

# ln -s ${CC} ./gcc
# export PATH=$PWD:$PATH
# CC=gcc

# ln -s $PREFIX/lib ./lib
# ln -s $PREFIX/include ./include

perl Makefile.PL EXPATLIBPATH=$PREFIX/lib EXPATINCPATH=$PREFIX/include INSTALLDIRS=site
make
make install
