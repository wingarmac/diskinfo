#!/bin/bash
# Script: diskinfo-lvm.sh
# Pour chaque disque contenant un PV LVM, ce script affiche :
#  - Le disque parent et sa taille
#  - La liste de toutes ses partitions :
#      • Les partitions non‑LVM (ex: /boot, /boot-efi) avec UUID, PARTUUID, mountpoint et, si applicable, leur espace via df
#      • Le bloc LVM (le PV servant de conteneur) avec le groupe LVM (lvm2) et sa taille,
#        suivi de la liste des volumes logiques (affichant pour chacun l'UUID et, pour ceux montés et non SWAP, la taille totale et l'espace libre)
# Set WORKING_DIR to the directory where this script resides
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKING_DIR" || { echo "Cannot change to $WORKING_DIR"; exit 1; }

# Define ANSI color codes
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${RED}LVM DISK INFO${RESET}"
echo -e "${RED}______________${RESET}"
echo ""

# On récupère la liste des disques qui possèdent au moins un PV LVM.
lvm_pvs=$(pvs --noheadings -o pv_name 2>/dev/null | awk '{$1=$1};1')
declare -A lvm_disks
for pv in $lvm_pvs; do
    base=$(basename "$pv")
    if [[ "$base" =~ ^(nvme[0-9]+n[0-9]+)p[0-9]+$ ]]; then
        disk_name="${BASH_REMATCH[1]}"
    else
        disk_name=$(echo "$base" | sed -E 's/[0-9]+$//')
    fi
    lvm_disks["$disk_name"]=1
done

# Pour chaque disque contenant un PV LVM, on affiche toutes ses partitions
for disk in "${!lvm_disks[@]}"; do
    disk_path="/dev/$disk"
    disk_size=$(lsblk -nd -o SIZE "$disk_path")
    echo "Volume: $disk		Size: $disk_size"
    
    # Liste toutes les partitions de ce disque
    parts=$(lsblk -nr -o NAME,TYPE,PKNAME | awk -v disk="$disk" '$3==disk && $2=="part" {print "/dev/"$1}')
    
    for part in $parts; do
        # Vérifie si cette partition est un PV LVM
        vg_name=$(pvs --noheadings -o vg_name "$part" 2>/dev/null | awk '{$1=$1};1')
        if [[ -n "$vg_name" ]]; then
            # On affiche le bloc LVM (une seule fois par VG)
            echo "  └─ lvm2: $vg_name		Size: $(lsblk -nd -o SIZE "$part")"
            # Liste des volumes logiques du groupe
            lvs --noheadings -o lv_name,lv_path "$vg_name" | while read -r lv_name lv_path; do
                lvm_uuid=$(blkid -s UUID -o value "$lv_path")
                lv_mount=$(lsblk -n -o MOUNTPOINT "$lv_path")
                if [[ -n "$lvm_uuid" ]]; then
                    if [[ -n "$lv_mount" ]]; then
                        echo "      ├─ $lv_path: UUID=$lvm_uuid"
                        echo "      └─ MOUNTPOINT=$lv_mount"
                    else
                        echo "      └─ $lv_path: UUID=$lvm_uuid"
                    fi
                else
                    if [[ -n "$lv_mount" ]]; then
                        echo "      ├─ $lv_path: (pas d'UUID trouvé)"
                        echo "      └─ MOUNTPOINT=$lv_mount"
                    else
                        echo "      └─ $lv_path: (pas d'UUID trouvé)"
                    fi
                fi
                # Affiche l'espace si le LV est monté et n'est pas SWAP
                if [[ -n "$lv_mount" && "$lv_mount" != "[SWAP]" ]]; then
                    df_out=$(df -BG "$lv_mount" | awk 'NR==2 {print $2, $4}')
                    total=${df_out%% *}
                    free=${df_out##* }
                    echo "      Size: $total		Left: $free"
                fi
            done
        else
            # Partition non-LVM
            uuid=$(blkid -s UUID -o value "$part")
            partuuid=$(blkid -s PARTUUID -o value "$part")
            mountpt=$(lsblk -n -o MOUNTPOINT "$part")
            if [[ -n "$mountpt" ]]; then
                echo "  ├─ $part: UUID=$uuid PARTUUID=$partuuid"
                echo "  └─ MOUNTPOINT=$mountpt"
            else
                echo "  └─ $part: UUID=$uuid PARTUUID=$partuuid"
            fi
            if [[ -n "$mountpt" && "$mountpt" != "/boot/efi" && "$mountpt" != "/boot" && "$mountpt" != "[SWAP]" ]]; then
                df_out=$(df -BG "$mountpt" | awk 'NR==2 {print $2, $4}')
                total=${df_out%% *}
                free=${df_out##* }
                echo "  Size: $total		Left: $free"
            fi
        fi
    done
    echo ""
done
