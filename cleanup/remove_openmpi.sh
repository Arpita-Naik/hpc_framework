#!/bin/bash

echo "Removing OpenMPI installation..."

rm -rf $HOME/hpc/openmpi
rm -rf $HOME/hpc_sources/openmpi-4.1.6
rm -f  $HOME/hpc_sources/openmpi-4.1.6.tar.gz

# Remove PATH entries
sed -i '/hpc\/openmpi\/bin/d' ~/.bashrc
sed -i '/hpc\/openmpi\/lib/d' ~/.bashrc

echo "OpenMPI completely removed."
echo "Run: source ~/.bashrc"