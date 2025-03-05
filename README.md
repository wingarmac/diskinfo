# Last upgrades (05-03-2025):
- Sizes per mounts
- Title and subtitles color codes
- Séparated script for raid information


# diskinfo install procedure

Disk information: raid, lvm, uuid, mount points, etc.

`git clone https://github.com/wingarmac/diskinfo/`

`cd diskinfo`

`sudo chmod a+x *.sh`

`sudo ./diskinfo.sh`

The LVM DISK INFO is the only part that requires `sudo` and can also be launched individually with `sudo ./lvm2info.sh`.


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

# [Intended: The following RAID info is in light green]
RAID DISK INFO
______________

RAID: raid0
RAID Device: /dev/md126
Members: /dev/sda,/dev/sdb
Partition: /dev/md126p1  Size: 931,5G
  ├─ UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  └─ MOUNTPOINT=/home/USERNAME
  Partition Size: 916G  Free: 663G

# [Intended: The following LVM info is in red]
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

