#!/bin/bash

echo "===== CHECKING SLURM STATUS ====="

SLURM_STATUS="not_installed"

if command -v sinfo &>/dev/null; then
    echo "Slurm command found."

    if systemctl list-unit-files | grep -q slurmctld; then
        echo "Slurm service found."

        if ! systemctl is-active --quiet munge; then
            echo "Munge not running."
            SLURM_STATUS="needs_configuration"

        elif systemctl is-active --quiet slurmctld; then
            echo "Slurm is running properly."
            SLURM_STATUS="installed"

        else
            echo "Slurm installed but not active."
            SLURM_STATUS="needs_configuration"
        fi

    else
        echo "Slurm partially installed."
        SLURM_STATUS="needs_configuration"
    fi

else
    echo "Slurm not installed."
    SLURM_STATUS="not_installed"
fi

export SLURM_STATUS
echo "Detected SLURM_STATUS=$SLURM_STATUS"