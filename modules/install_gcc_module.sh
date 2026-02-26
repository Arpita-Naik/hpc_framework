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
mkdir -p build
cd build

echo "Configuring GCC..."
../configure --prefix=$INSTALL_DIR --enable-languages=c,c++ --disable-multilib

echo "Building GCC (this will take time)..."
make -j$(nproc)

echo "Installing GCC..."
make install

echo "GCC Installation Completed!"