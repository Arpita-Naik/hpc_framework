#!/bin/bash
set -e

echo "===== FULL HPC RESET START ====="

if [[ $EUID -ne 0 ]]; then
   echo "Run as root"
   exit 1
fi

echo "Stopping services..."
systemctl stop slurmctld 2>/dev/null || true
systemctl stop slurmd 2>/dev/null || true
systemctl stop slurmdbd 2>/dev/null || true
systemctl stop munge 2>/dev/null || true

systemctl disable slurmctld 2>/dev/null || true
systemctl disable slurmd 2>/dev/null || true
systemctl disable slurmdbd 2>/dev/null || true
systemctl disable munge 2>/dev/null || true

echo "Removing Slurm and Munge packages..."

if command -v apt &>/dev/null; then
    apt purge -y slurm-wlm munge slurmctld slurmd slurmdbd 2>/dev/null || true
    apt autoremove -y
elif command -v dnf &>/dev/null; then
    dnf remove -y slurm munge slurm-slurmctld slurm-slurmd slurm-slurmdbd 2>/dev/null || true
fi

echo "Removing configuration directories..."
rm -rf /etc/slurm
rm -rf /etc/munge
rm -rf /var/lib/munge
rm -rf /var/log/munge
rm -rf /run/munge
rm -rf /var/spool/slurmctld
rm -rf /var/spool/slurmd

echo "Removing users..."
userdel slurm 2>/dev/null || true
userdel munge 2>/dev/null || true

echo "Reloading systemd..."
systemctl daemon-reload

echo "===== FULL HPC RESET COMPLETE ====="
echo "You may reboot now."
