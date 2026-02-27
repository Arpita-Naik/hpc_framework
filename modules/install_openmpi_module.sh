#!/bin/bash

set -e

INSTALL_DIR=$HOME/hpc/openmpi
SRC_DIR=$HOME/hpc_sources

mkdir -p $SRC_DIR
mkdir -p $INSTALL_DIR
cd $SRC_DIR

echo "Downloading OpenMPI..."
wget -nc https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.6.tar.gz

echo "Extracting OpenMPI..."
tar -xf openmpi-4.1.6.tar.gz
cd openmpi-4.1.6

echo "Configuring OpenMPI..."
./configure --prefix=$INSTALL_DIR

echo "Building OpenMPI..."
make -j$(nproc)

echo "Installing OpenMPI..."
make install

# ✅ Add OpenMPI to PATH (if not already added)
if ! grep -q 'hpc/openmpi/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/hpc/openmpi/bin:$PATH"' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH="$HOME/hpc/openmpi/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
fi

echo "OpenMPI Installation Completed!"
echo "Run: source ~/.bashrc"
echo "Then check with: mpirun --version"