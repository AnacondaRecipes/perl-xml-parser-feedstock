#!/bin/bash

#chmod 644 samples/{canonical,xml*}
#perl -pi -e 's|^#!/usr/local/bin/perl\b|#!${PREFIX}/bin/perl|' samples/{canonical,xml*}

# Remove bundled library
#rm -r inc
#sed -i -e '/^inc\// d' MANIFEST


perl Makefile.PL EXPATLIBPATH=$PREFIX/lib EXPATINCPATH=$PREFIX/include INSTALLDIRS=site
make
make install
