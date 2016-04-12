#!/bin/bash

set -e

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

# download the real configure script
curl -s --fail https://raw.githubusercontent.com/pghalliday-dotfiles/arch-linux-vm/master/configure.sh > /mnt/configure.sh
chmod +x /mnt/configure.sh

# configure using chroot
arch-chroot /mnt ./configure.sh "$DEVICE" "$HOSTNAME"

# unmount the partitions and reboot
umount -R /mnt
reboot
