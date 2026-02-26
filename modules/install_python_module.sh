#!/bin/bash

set -e

INSTALL_DIR=$HOME/hpc/python
SRC_DIR=$HOME/hpc_sources

mkdir -p $SRC_DIR
mkdir -p $INSTALL_DIR
cd $SRC_DIR

echo "Downloading Python..."
wget -nc https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tar.xz

echo "Extracting Python..."
tar -xf Python-3.12.1.tar.xz
cd Python-3.12.1

echo "Configuring Python..."
./configure --prefix=$INSTALL_DIR --enable-optimizations

echo "Building Python..."
make -j$(nproc)

echo "Installing Python..."
make install

echo "Python Installation Completed!"