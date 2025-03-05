#!/bin/bash
# Script: raidinfo.sh
# This script displays RAID disk information for unique RAID partitions:
#  - For each partition whose parent disk is a RAID device (e.g. /dev/md*),
#    it shows the RAID type, the ordered list of RAID members (via mdadm),
#    the partition's own size (not the RAID device size),
#    and partition details including UUID, PARTUUID, mountpoint,
#    plus size/free space if the partition is mounted.
#
# Set WORKING_DIR to the directory where this script resides.
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKING_DIR" || { echo "Cannot change to $WORKING_DIR"; exit 1; }

# Define ANSI color codes
LIGHT_GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${LIGHT_GREEN}RAID DISK INFO${RESET}"
echo -e "${LIGHT_GREEN}______________${RESET}"
echo ""


# Declare an associative array to keep track of processed RAID partitions.
declare -A processed_partitions

# Get a list of all partitions.
partitions=$(lsblk -nr -o NAME,TYPE,PKNAME | awk '$2=="part" && $3!="" {print "/dev/"$1}')

for part in $partitions; do
    # Skip partitions that are LVM physical volumes.
    is_lvm_pv=$(pvs --noheadings -o pv_name "$part" 2>/dev/null | wc -l)
    if [[ "$is_lvm_pv" -eq 0 ]]; then
        parent_disk=$(lsblk -n -o PKNAME "$part")
        # Process only RAID devices (those with 'md' in their parent disk name)
        if [[ "$parent_disk" == *md* ]]; then
            # Skip this partition if it has already been processed
            if [[ -n "${processed_partitions[$part]}" ]]; then
                continue
            fi
            processed_partitions["$part"]=1

            raid_device="/dev/$parent_disk"
            # Retrieve RAID type from sysfs (e.g. raid0, raid1)
            raid_type=$(cat /sys/block/"$parent_disk"/md/level 2>/dev/null)
            # Get the ordered list of RAID members via mdadm
            raid_members=$(mdadm --detail "$raid_device" 2>/dev/null | awk '/^[[:space:]]*[0-9]+/ {print $NF}' | paste -sd ', ' -)
            # Get the partition's own size
            part_size=$(lsblk -nd -o SIZE "$part")
            
            echo "RAID: $raid_type"
            echo "  RAID Device: $raid_device"
            echo "  Members: $raid_members"
            echo "  Partition: $part    Size: $part_size"
            
            # Retrieve partition details: UUID, PARTUUID, and mount point.
            uuid=$(blkid -s UUID -o value "$part")
            partuuid=$(blkid -s PARTUUID -o value "$part")
            mountpoint=$(lsblk -n -o MOUNTPOINT "$part")
            
            if [[ -n "$mountpoint" ]]; then
                echo "    ├─ UUID=$uuid PARTUUID=$partuuid"
                echo "    └─ MOUNTPOINT=$mountpoint"
            else
                echo "    └─ UUID=$uuid PARTUUID=$partuuid"
            fi
            
            # If mounted (and not EFI or SWAP), display partition size and free space.
            if [[ -n "$mountpoint" && "$mountpoint" != "/boot/efi" && "$mountpoint" != "[SWAP]" ]]; then
                df_out=$(df -BG "$mountpoint" | awk 'NR==2 {print $2, $4}')
                total=${df_out%% *}
                free=${df_out##* }
                echo "    Partition Size: $total    Free: $free"
            fi
            echo ""
        fi
    fi
done
