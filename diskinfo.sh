#!/bin/bash
# Version améliorée : ajout de la taille de chaque disque
# Parametrage du repertoire source WORKING_DIR ou le script reside.
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKING_DIR" || { echo "Cannot change to $WORKING_DIR"; exit 1; }

echo "DISK INFO"
echo "_________"
echo ""

# Récupère les partitions liées à un disque
partitions=$(lsblk -nr -o NAME,TYPE,PKNAME | awk '$2=="part" && $3!="" {print "/dev/"$1}')

echo "Non-LVM partitions:"
for part in $partitions; do
    # Si la partition n'est pas un PV LVM
    is_lvm_pv=$(pvs --noheadings -o pv_name "$part" 2>/dev/null | wc -l)
    if [[ "$is_lvm_pv" -eq 0 ]]; then
        parent_disk=$(lsblk -n -o PKNAME "$part")
        disk_path="/dev/$parent_disk"
        disk_size=$(lsblk -nd -o SIZE "$disk_path")
        
        # Affichage du type et de la taille du disque parent
        if [[ "$parent_disk" == *md* ]]; then
            raid_type=$(cat /sys/block/"$parent_disk"/md/level 2>/dev/null)
            echo "raid: $raid_type		Size: $disk_size"
        else
            echo "volume: $parent_disk		Size: $disk_size"
        fi
        
        # Récupération des infos de la partition
        uuid=$(blkid -s UUID -o value "$part")
        partuuid=$(blkid -s PARTUUID -o value "$part")
        mountpoint=$(lsblk -n -o MOUNTPOINT "$part")
        
        if [[ -n "$mountpoint" ]]; then
            echo "  ├─ $part: UUID=$uuid PARTUUID=$partuuid"
            echo "  └─ MOUNTPOINT=$mountpoint"
        else
            echo "  └─ $part: UUID=$uuid PARTUUID=$partuuid"
        fi
        
        # Pour une partition montée (hors EFI et SWAP), afficher la taille et l'espace libre
        if [[ -n "$mountpoint" && "$mountpoint" != "/boot/efi" && "$mountpoint" != "[SWAP]" ]]; then
            df_out=$(df -BG "$mountpoint" | awk 'NR==2 {print $2, $4}')
            total=${df_out%% *}
            free=${df_out##* }
            echo "  Size: $total		Left: $free"
        fi
        echo ""
    fi
done

echo "LVM DISK INFO"
echo "_________"
echo ""
./lvm2info.sh
