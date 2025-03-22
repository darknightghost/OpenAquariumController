#! /bin/bash

SRC_DIR="$1"
INSTALL_DIR="$2"

CPU_COUNT=$(($(cat /proc/cpuinfo | grep "^processor[[:space:]]\\+:" | wc -l) + 1))

# Clone sources.
cd "${SRC_DIR}"
git clone "https://github.com/Icenowy/sunxi-tools.git" || exit $?

# Build.
cd sunxi-tools
git checkout v3s-spi || exit $?
make -j ${CPU_COUNT} || exit $?
make install DESTDIR="${INSTALL_DIR}" || exit $?
