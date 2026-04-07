#!/bin/bash

set -x

cd "$SRC_DIR"

export PATH=$PREFIX/bin:$PATH

export EXPATLIBPATH="${PREFIX}/lib"
export EXPATINCPATH="${PREFIX}/include"
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

export CC="${CC}"
# EU::MM runs $(LD) with LDFLAGS that include -Wl,...; those flags are for the compiler driver,
# not for bare ld(1). Use the same driver as CC (conda sets ...-gnu-cc).
export LD="${CC}"
export OPTIMIZE="${CFLAGS}"
export PERL_MM_OPT="CC=${CC} LD=${CC}"

echo "Invoking ${PREFIX}/bin/perl ..."

${PREFIX}/bin/perl Makefile.PL INSTALLDIRS=site

# EU::MM copies Perl's Config into Expat/Makefile (CCFLAGS etc.). That embeds another build's
# --sysroot=/home/task.../croot/perl_.../sysroot. GCC uses the *last* --sysroot; that stale
# path wins over our OPTIMIZE/CFLAGS and breaks system headers (stdlib.h). Strip those paths
# from generated Makefiles, then append the active sysroot last on OPTIMIZE.
if [[ -n "${CONDA_BUILD_SYSROOT:-}" && "${OSTYPE:-unknown}" == linux* ]]; then
  _fix_makefile_sysroot() {
    local f="$1"
    [[ -f "$f" ]] || return 0
    sed -i.bak \
      -e 's|--sysroot=/home/task[^[:space:]]*||g' \
      -e 's|--sysroot=[^[:space:]]*croot/perl_[^[:space:]]*||g' \
      -e 's|--sysroot=\$BUILD_PREFIX/[^[:space:]]*||g' \
      "$f"
  }
  _fix_makefile_sysroot "${SRC_DIR}/Makefile"
  _fix_makefile_sysroot "${SRC_DIR}/Expat/Makefile"
  if [[ -f "${SRC_DIR}/Expat/Makefile" ]]; then
    cat >> "${SRC_DIR}/Expat/Makefile" <<EOF

# conda-build: last --sysroot must be this env's sysroot (see recipe build.sh).
OPTIMIZE := \$(OPTIMIZE) -isystem ${CONDA_BUILD_SYSROOT}/usr/include --sysroot=${CONDA_BUILD_SYSROOT}
EOF
  fi
fi

make OPTIMIZE="${CFLAGS}" CC="${CC}" LD="${LD}"
make install OPTIMIZE="${CFLAGS}" CC="${CC}" LD="${LD}"
