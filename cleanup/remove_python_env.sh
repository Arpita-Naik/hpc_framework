#!/bin/bash

echo "Removing Python installation..."

rm -rf $HOME/hpc/python
rm -rf $HOME/hpc_sources/Python-3.12.1
rm -f  $HOME/hpc_sources/Python-3.12.1.tar.xz

# Remove PATH entry
sed -i '/hpc\/python\/bin/d' ~/.bashrc

echo "Python completely removed."
echo "Run: source ~/.bashrc"