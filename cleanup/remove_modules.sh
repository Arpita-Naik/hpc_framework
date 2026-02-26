#!/bin/bash

echo "Removing GCC installation..."

# Remove installed directory
rm -rf $HOME/hpc/gcc

# Remove extracted source and tar file
rm -rf $HOME/hpc_sources/gcc-13.2.0
rm -f  $HOME/hpc_sources/gcc-13.2.0.tar.gz

# Remove PATH entry
sed -i '/hpc\/gcc/d' $HOME/.bashrc

echo "GCC completely removed."

echo "Removing OpenMPI installation..."

# Remove installed directory
rm -rf $HOME/hpc/openmpi

# Remove extracted source and tar file
rm -rf $HOME/hpc_sources/openmpi-4.1.6
rm -f  $HOME/hpc_sources/openmpi-4.1.6.tar.gz

# Remove PATH and LD_LIBRARY_PATH entries
sed -i '/hpc\/openmpi/d' $HOME/.bashrc

echo "OpenMPI completely removed."