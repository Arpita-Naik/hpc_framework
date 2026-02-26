#!/bin/bash
set -e

echo "===== HPC FRAMEWORK START ====="

if [[ $EUID -ne 0 ]]; then
   echo "Run as root: sudo ./master_setup.sh"
   exit 1
fi

# OS Detection
source system_check/detect_os.sh
echo "===== OS CHECK COMPLETE ====="

# Slurm Preprocess
source slurm/preprocess_slurm.sh
echo "--------------------------------"

if [[ "$SLURM_STATUS" == "installed" ]]; then
    echo "Slurm fully configured. Skipping installation."

elif [[ "$SLURM_STATUS" == "needs_configuration" ]]; then
    echo "Slurm exists but needs configuration."
    bash slurm/configure_slurm.sh

elif [[ "$SLURM_STATUS" == "not_installed" ]]; then
    echo "Slurm not installed."
    bash slurm/install_slurm.sh
    bash slurm/configure_slurm.sh

else
    echo "Unknown Slurm status."
    exit 1
fi

echo "Verifying Munge..."
if ! systemctl is-active --quiet munge; then
    systemctl restart munge || true
fi

if ! systemctl is-active --quiet munge; then
    echo "Munge failed. Stopping setup."
    exit 1
fi

echo "Setting up GCC..."
bash modules/install_gcc_module.sh
echo "--------------------------------"

echo "Setting up Python..."
bash modules/install_python_module.sh
echo "--------------------------------"

echo "Setting up OpenMPI..."
bash modules/install_openmpi_module.sh
echo "--------------------------------"

echo "Verifying Slurm..."
sleep 2
command -v sinfo && sinfo || echo "Slurm installed but not responding."

echo "===== HPC FRAMEWORK SETUP COMPLETE ====="