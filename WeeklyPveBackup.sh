#!/bin/bash

# 1. Mount NFS
mountpoint -q /mnt/nas || mount -t nfs 192.168.1.2:/volume1/PVE_Backup /mnt/nas

# 2. Backup dir
BACKUP_DIR="/mnt/nas/vzdump"
mkdir -p "$BACKUP_DIR"

# 3. Backup VM list
VM_LIST=(100 101)

# 4. Backup and maintain the maximum backup number
for vmid in "${VM_LIST[@]}"; do
    vzdump $vmid --mode stop --compress zstd --dumpdir "$BACKUP_DIR"

    # Clean backups, only remain most recent backups
    ls -tp "$BACKUP_DIR"/vzdump-qemu-${vmid}-*.vma.zst 2>/dev/null | grep -v '/$' | tail -n +5 | xargs -r rm --
done
