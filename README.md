# diskinfo install procedure

Disk information: raid, lvm, uuid, mount points, etc.

`git clone https://github.com/wingarmac/diskinfo/`

`cd diskinfo`

`sudo chmod a+x *.sh`

`sudo ./diskinfo.sh`

The `./lvm2info.sh` is the only part that requires `sudo` and can also be launched individually with `sudo ./lvm2info.sh`.

```
DISK INFO
_________

Non-LVM partitions:
raid: raid0                Size: #
  ├─ /dev/md126p1: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/home/wingarmac
  Size: #            Left: #

raid: raid0                Size: #
  ├─ /dev/md126p1: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/home/wingarmac
  Size: #            Left: #

volume: nvme1n1          Size: #
  └─ /dev/nvme1n1p1: UUID=## PARTUUID=##

volume: nvme1n1          Size: #
  ├─ /dev/nvme1n1p2: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/mnt/ubuntu-desktop
  Size: #            Left: #

volume: nvme1n1          Size: #
  ├─ /dev/nvme1n1p5: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/mnt/lanshare
  Size: #            Left: #

volume: nvme1n1          Size: #
  ├─ /dev/nvme1n1p7: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/mnt/some-mountpoint  # Replaced UUID with generic name
  Size: #            Left: #

volume: nvme2n1          Size: #
  ├─ /dev/nvme2n1p1: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/boot/efi

volume: nvme2n1          Size: #
  ├─ /dev/nvme2n1p2: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/boot
  Size: #            Left: #

volume: nvme0n1         Size: #
  ├─ /dev/nvme0n1p1: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/mnt/virt-nvme
  Size: #            Left: #

LVM DISK INFO
_________

Volume: nvme2n1          Size: #
  ├─ /dev/nvme2n1p1: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/boot/efi
  ├─ /dev/nvme2n1p2: UUID=## PARTUUID=##
  └─ MOUNTPOINT=/boot
  └─ lvm2: cinnamon-vg      Size: #
      ├─ /dev/cinnamon-vg/swap: UUID=##
      └─ MOUNTPOINT=[SWAP]
      ├─ /dev/cinnamon-vg/ubuntu_cin: UUID=##
      └─ MOUNTPOINT=/
      Size: #            Left: #
