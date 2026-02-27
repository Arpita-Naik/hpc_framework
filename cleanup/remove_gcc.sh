#!/bin/bash

echo "Removing GCC installation..."

rm -rf $HOME/hpc/gcc
rm -rf $HOME/hpc_sources/gcc-13.2.0
rm -f  $HOME/hpc_sources/gcc-13.2.0.tar.gz

# Remove PATH entry
sed -i '/hpc\/gcc\/bin/d' ~/.bashrc

echo "GCC completely removed."
echo "Run: source ~/.bashrc"