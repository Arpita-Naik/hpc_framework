#!/bin/bash

set -e

INSTALL_DIR=$HOME/hpc/gcc
SRC_DIR=$HOME/hpc_sources

mkdir -p $SRC_DIR
mkdir -p $INSTALL_DIR
cd $SRC_DIR

echo "Downloading GCC..."
wget -nc https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz

echo "Extracting GCC..."
tar -xf gcc-13.2.0.tar.gz
cd gcc-13.2.0

# Optional but recommended: download prerequisites
if [ ! -f "contrib/download_prerequisites" ]; then
    echo "Prerequisite script not found"
else
    ./contrib/download_prerequisites
fi

mkdir -p build
cd build

echo "Configuring GCC..."
../configure --prefix=$INSTALL_DIR --enable-languages=c,c++ --disable-multilib

echo "Building GCC (this will take time)..."
make -j$(nproc)

echo "Installing GCC..."
make install

# ✅ Add GCC to PATH (only if not already added)
if ! grep -q 'hpc/gcc/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/hpc/gcc/bin:$PATH"' >> ~/.bashrc
fi

echo "GCC Installation Completed!"
echo "Run: source ~/.bashrc"
echo "Then check with: gcc --version"