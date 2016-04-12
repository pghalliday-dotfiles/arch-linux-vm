#!/bin/bash

set -e

DEFAULT_DEVICE=/dev/sda2

DEVICE=$1
if [ -z "$DEVICE" ]; then
  DEVICE=$DEFAULT_DEVICE
fi

curl -s --fail https://raw.githubusercontent.com/pghalliday-dotfiles/arch-linux-vm/master/configure.sh > /mnt/configure.sh
chmod +x /mnt/configure.sh
arch-chroot /mnt "./configure.sh $DEVICE"
