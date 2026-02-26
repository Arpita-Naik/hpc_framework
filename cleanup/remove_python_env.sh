#!/bin/bash

echo "Removing Python installation..."

# Remove installed directory
rm -rf $HOME/hpc/python

# Remove extracted source and tar file
rm -rf $HOME/hpc_sources/Python-3.12.1
rm -f  $HOME/hpc_sources/Python-3.12.1.tar.xz

# Remove PATH entry
sed -i '/hpc\/python/d' $HOME/.bashrc

echo "Python completely removed."