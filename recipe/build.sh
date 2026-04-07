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

# Perl's Config bakes in another build's --sysroot; strip it and end with this env's sysroot.
if [[ -n "${CONDA_BUILD_SYSROOT:-}" && "${OSTYPE:-}" == linux* ]]; then
  for mk in "${SRC_DIR}/Makefile" "${SRC_DIR}/Expat/Makefile"; do
    [[ -f "$mk" ]] || continue
    sed -i.bak \
      -e 's|--sysroot=/home/task[^[:space:]]*||g' \
      -e 's|--sysroot=[^[:space:]]*croot/perl_[^[:space:]]*||g' \
      -e 's|--sysroot=\$BUILD_PREFIX/[^[:space:]]*||g' \
      "$mk"
  done
  if [[ -f "${SRC_DIR}/Expat/Makefile" ]]; then
    cat >> "${SRC_DIR}/Expat/Makefile" <<EOF

OPTIMIZE := \$(OPTIMIZE) -isystem ${CONDA_BUILD_SYSROOT}/usr/include --sysroot=${CONDA_BUILD_SYSROOT}
EOF
  fi
fi

make
make install
