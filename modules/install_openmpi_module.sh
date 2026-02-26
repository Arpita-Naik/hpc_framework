#!/bin/bash

echo "===== OPENMPI SETUP ====="

if command -v mpirun &> /dev/null; then
    echo "OpenMPI already installed."
    exit 0
fi

if [ "$PKG_MANAGER" == "apt" ]; then
    sudo apt install -y openmpi-bin libopenmpi-dev
elif [ "$PKG_MANAGER" == "dnf" ]; then
    sudo dnf install -y openmpi openmpi-devel
else#!/bin/bash

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

echo "OpenMPI Installation Completed!"
    echo "Unsupported package manager."
    exit 1
fi

echo "OpenMPI installation complete."