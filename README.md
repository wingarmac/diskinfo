# Diskinfo

A simple script to display disk information.
Made on Ubuntu (24.10) levarging the official repos.

## Features

Leveraging several tools:

`lsblk` Lists block devices, showing relationships between disks, partitions, and mount points.

`blkid` Identifies block devices and displays attributes such as UUID, PARTUUID, and filesystem type.

`pvs` Shows physical volumes used by LVM (Logical Volume Manager).

`lvs` Lists logical volumes within an LVM volume group.

`mdadm` Manages software RAID arrays, providing detailed status and configuration options.

`df` Displays filesystem usage information, including total size and free space on mounted partitions.

# Last upgrades (06-03-2025):
Granular control and menu adiditon with pre-selection for standard or dialog menu at start of it.

## Upgrades (05-03-2025):
- Sizes per mounts
- Title and subtitles color codes
- Séparated script for raid information


## diskinfo install procedure

Disk information: raid, lvm, uuid, mount points, etc.

1. `git clone https://github.com/wingarmac/diskinfo/`

2. `cd diskinfo`

3. `sudo chmod a+x *.sh`

A. You can now manualy start the disired output with te wanted script since 06-03-2025

- `./diskinfo.sh` - ext4 drives
 
- `./raidinfo.sh` - raid drives

- `sudo ./lvm2info.sh` - lvm drives (only one that requiring root privilleges)

- `sudo ./combined.sh` - for all togheter

B. With `./diskdialog.sh`

At start of the script it will ask for requirements depending on your choices using dialog that require the package or lvm that requires privilleges

B.1. You can make usage of the nomal menu 

```
~$ diskinfo/diskdialog.sh
Use dialog for the menu? [y/N] N
Select Disk Information:
1) All Information
2) Standard Disks
3) RAID Information
4) LVM Information
5) Exit
#? 

```
B.2. With dialog:

![image](https://github.com/user-attachments/assets/5ee558a2-a1e9-43f5-997c-43b1f0c76f30)

Full output example:

```
# (The following headings are color-coded when running in your terminal:)
# Main title is in lighter blue, subtitles in light blue,
# RAID info in light green, and LVM info in red.

______________
DISK INFO
______________

Standard disks and partitions:
______________________________

volume: nvme1n1   Size: 119,2G
  └─ /dev/nvme1n1p1: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX

volume: nvme1n1   Size: 119,2G
  ├─ /dev/nvme1n1p2: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/mnt/OS-BOOT
  Size: 59G    Left: 43G

volume: nvme1n1   Size: 119,2G
  ├─ /dev/nvme1n1p5: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/mnt/LANSHARE
  Size: 40G    Left: 38G

volume: nvme1n1   Size: 119,2G
  ├─ /dev/nvme1n1p7: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/mnt/SECOND-MOUNT
  Size: 18G    Left: 17G

volume: nvme0n1   Size: 465,8G
  ├─ /dev/nvme0n1p1: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/mnt/VIRT
  Size: 458G   Left: 395G

volume: nvme2n1   Size: 465,8G
  ├─ /dev/nvme2n1p1: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/boot/efi

volume: nvme2n1   Size: 465,8G
  ├─ /dev/nvme2n1p2: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/boot
  Size: 2G     Left: 2G

RAID DISK INFO
______________

RAID: raid0
RAID Device: /dev/md126
Members: /dev/sda,/dev/sdb
Partition: /dev/md126p1  Size: 931,5G
  ├─ UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/home/USERNAME
  Partition Size: 916G  Free: 663G

LVM DISK INFO
______________

Volume: nvme2n1   Size: 465,8G
  ├─ /dev/nvme2n1p1: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/boot/efi
  ├─ /dev/nvme2n1p2: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/boot
  └─ lvm2: VG_NAME   Size: 462,7G
      ├─ /dev/VG_NAME/swap: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
      └─ MOUNTPOINT=[SWAP]
      ├─ /dev/VG_NAME/OS_ROOT: UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
      └─ MOUNTPOINT=/
      Size: 448G   Left: 360G
```

## Inventory of used collors

| Couleur        | Code ANSI     | Pastille                                                                                 | Code HEX    |
|----------------|---------------|-------------------------------------------------------------------------------------------|-------------|
| **Lighter Blue** (titre) | ``\033[1;94m`` | ![#1E90FF](https://placehold.co/15x15/1E90FF/1E90FF.png) `#1E90FF`  | `#1E90FF`   |
| **Light Blue** (sous-titre) | ``\033[1;34m`` | ![#0000FF](https://placehold.co/15x15/0000FF/0000FF.png) `#0000FF`   | `#0000FF`   |
| **Light Green** (RAID)     | ``\033[1;32m`` | ![#32CD32](https://placehold.co/15x15/32CD32/32CD32.png) `#32CD32`   | `#32CD32`   |
| **Red** (LVM)              | ``\033[1;31m`` | ![#FF0000](https://placehold.co/15x15/FF0000/FF0000.png) `#FF0000`   | `#FF0000`   |

> **Note:** Exact colors may vary by device and theme (light/dark). The HEX codes above are just visual approximations to give an idea.  

These ANSI sequences are followed by ``\033[0m`` to reset the color (`$RESET` variable in your scripts).
