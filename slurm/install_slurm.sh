#!/bin/bash
set -e

echo "===== INSTALLING SLURM & MUNGE ====="

# Detect package manager automatically
if command -v apt &>/dev/null; then
    echo "Detected Debian/Ubuntu system"
    apt update
    apt install -y slurm-wlm munge mariadb-server

elif command -v dnf &>/dev/null; then
    echo "Detected Fedora/RHEL system"

    # Disable weak deps to avoid multilib conflicts
    sudo dnf install -y \
        --setopt=install_weak_deps=False \
        munge \
        slurm \
        slurm-slurmd \
        slurm-slurmctld || {
            echo "DNF installation failed."
            exit 1
        }

else
    echo "Unsupported package manager."
    exit 1
fi

# Ensure slurm user exists
if ! id slurm &>/dev/null; then
    echo "Creating slurm user..."
    useradd -r -M -s $(which nologin) slurm
fi

# Ensure munge user exists
if ! id munge &>/dev/null; then
    echo "Creating munge user..."
    useradd -r -M -s $(which nologin) munge
fi

echo "===== INSTALLATION COMPLETE ====="