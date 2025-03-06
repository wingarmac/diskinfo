#!/bin/bash
# diskinfo.sh - Main script for disk info, excluding RAID and LVM which are handled separately.

# Define ANSI color codes
LIGHTER_BLUE="\033[1;94m"  # for main title (lighter blue)
LIGHT_BLUE="\033[1;34m"    # for subtitle (light blue)
RESET="\033[0m"

# Set WORKING_DIR to the directory where this script resides.
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKING_DIR" || { echo "Cannot change to $WORKING_DIR"; exit 1; }

# Main Title (lighter blue)
echo ""
echo -e "${LIGHTER_BLUE}______________${RESET}"
echo ""
echo -e "${LIGHTER_BLUE}DISK INFO${RESET}"
echo -e "${LIGHTER_BLUE}______________${RESET}"
echo ""

# Subtitle for standard (non-RAID, non-LVM) disks (light blue)
echo -e "${LIGHT_BLUE}Standard disks and partitions:${RESET}"
echo -e "${LIGHT_BLUE}______________________________${RESET}"
echo ""

# Get all partitions.
partitions=$(lsblk -nr -o NAME,TYPE,PKNAME | awk '$2=="part" && $3!="" {print "/dev/"$1}')

for part in $partitions; do
    # Skip if partition is an LVM physical volume.
    is_lvm_pv=$(pvs --noheadings -o pv_name "$part" 2>/dev/null | wc -l)
    parent_disk=$(lsblk -n -o PKNAME "$part")
    # Exclude RAID partitions (parent contains "md")
    if [[ "$is_lvm_pv" -eq 0 && "$parent_disk" != *md* ]]; then
        disk_path="/dev/$parent_disk"
        disk_size=$(lsblk -nd -o SIZE "$disk_path")
        echo "volume: $parent_disk		Size: $disk_size"
        
        # Retrieve partition details.
        uuid=$(blkid -s UUID -o value "$part")
        partuuid=$(blkid -s PARTUUID -o value "$part")
        mountpoint=$(lsblk -n -o MOUNTPOINT "$part")
        
        if [[ -n "$mountpoint" ]]; then
            echo "  ├─ $part: UUID=$uuid PARTUUID=$partuuid"
            echo "  └─ MOUNTPOINT=$mountpoint"
        else
            echo "  └─ $part: UUID=$uuid PARTUUID=$partuuid"
        fi
        
        # If the partition is mounted (and not EFI or SWAP), show size and free space.
        if [[ -n "$mountpoint" && "$mountpoint" != "/boot/efi" && "$mountpoint" != "[SWAP]" ]]; then
            df_out=$(df -BG "$mountpoint" | awk 'NR==2 {print $2, $4}')
            total=${df_out%% *}
            free=${df_out##* }
            echo "  Size: $total		Left: $free"
        fi
        echo ""
    fi
done

