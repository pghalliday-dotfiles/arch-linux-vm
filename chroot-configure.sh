#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DEFAULT_DEVICE=/dev/sda2
DEVICE=$1
if [ -z "$DEVICE" ]; then
  DEVICE=$DEFAULT_DEVICE
fi

DEFAULT_HOSTNAME=arch-linux
HOSTNAME=$2
if [ -z "$HOSTNAME" ]; then
  HOSTNAME=$DEFAULT_HOSTNAME
fi

#  copy the real configure script to the mount point
cp -f $DIR/configure.sh /mnt/

# configure using chroot
arch-chroot /mnt ./configure.sh "$DEVICE" "$HOSTNAME"

# unmount the partitions and reboot
umount -R /mnt
reboot
