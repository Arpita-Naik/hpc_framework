#!/bin/bash
set -e

echo "===== CONFIGURING SLURM ====="

if [[ $EUID -ne 0 ]]; then
    echo "Run as root (sudo ./master_setup.sh)"
    exit 1
fi

HOSTNAME=$(hostname)
CPUS=$(nproc)

echo "Host: $HOSTNAME"
echo "CPUs: $CPUS"


if ! id munge &>/dev/null; then
    echo "Creating munge user..."
    useradd -r -M -s /sbin/nologin munge
fi

# Slurm user (Fedora does NOT auto-create)
if ! id slurm &>/dev/null; then
    echo "Creating slurm user..."
    useradd -r -M -s /sbin/nologin slurm
fi


echo "Configuring Munge..."

mkdir -p /etc/munge
mkdir -p /var/lib/munge
mkdir -p /var/log/munge
mkdir -p /run/munge

if [ ! -f /etc/munge/munge.key ]; then
    echo "Generating munge key..."
    if [ -x /usr/sbin/create-munge-key ]; then
        /usr/sbin/create-munge-key
    else
        dd if=/dev/urandom bs=1 count=1024 of=/etc/munge/munge.key
    fi
fi

chown -R munge:munge /etc/munge
chown -R munge:munge /var/lib/munge
chown -R munge:munge /var/log/munge
chown munge:munge /run/munge

chmod 0700 /etc/munge
chmod 0700 /var/lib/munge
chmod 0700 /var/log/munge
chmod 0755 /run/munge
chmod 0400 /etc/munge/munge.key

systemctl daemon-reload
systemctl enable munge
systemctl restart munge

if ! systemctl is-active --quiet munge; then
    echo "Munge failed to start."
    journalctl -xeu munge | tail -20
    exit 1
fi

echo "Munge running successfully."



mkdir -p /var/spool/slurmctld
mkdir -p /var/spool/slurmd

chown -R slurm:slurm /var/spool/slurmctld
chown -R slurm:slurm /var/spool/slurmd



echo "Creating slurm.conf..."

mkdir -p /etc/slurm

cat > /etc/slurm/slurm.conf <<EOF
ClusterName=localcluster
SlurmctldHost=$HOSTNAME
SlurmUser=slurm
SlurmdUser=root
StateSaveLocation=/var/spool/slurmctld
SlurmdSpoolDir=/var/spool/slurmd
AuthType=auth/munge
ProctrackType=proctrack/cgroup
TaskPlugin=task/affinity
SchedulerType=sched/backfill
SelectType=select/cons_tres

NodeName=$HOSTNAME CPUs=$CPUS State=UNKNOWN
PartitionName=debug Nodes=$HOSTNAME Default=YES MaxTime=INFINITE State=UP
EOF


systemctl daemon-reload
systemctl enable slurmctld
systemctl enable slurmd

systemctl restart slurmctld
systemctl restart slurmd

sleep 3


echo "===== VERIFYING SLURM ====="

if systemctl is-active --quiet slurmctld && systemctl is-active --quiet slurmd; then
    echo "Slurm services are running."
else
    echo "Slurm services failed."
    journalctl -xeu slurmctld | tail -20
    exit 1
fi

sinfo || echo "Slurm running but partition not responding."

echo "===== CONFIGURATION COMPLETE ====="