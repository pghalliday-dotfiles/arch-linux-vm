#!/bin/bash

set -e

DEFAULT_DEVICE=/dev/sda

DEVICE=$1
if [ -z "$DEVICE" ]; then
  DEVICE=$DEFAULT_DEVICE
fi

# make sure the device is not in use
umount /mnt/boot || true
umount /mnt/home || true
umount /mnt || true
swapoff ${DEVICE}3 || true

# create the partition table
parted -s $DEVICE mklabel gpt
parted -s $DEVICE mkpart ESP fat32 1MiB 513MiB
parted -s $DEVICE mkpart primary ext4 513MiB 20.5GiB
parted -s $DEVICE mkpart primary linux-swap 20.5GiB 24.5GiB
parted -s $DEVICE mkpart primary ext4 24.5GiB 100%

# intialise the partition
mkfs.fat -F32 ${DEVICE}1
mkfs.ext4 ${DEVICE}2
mkswap ${DEVICE}3
swapon ${DEVICE}3
mkfs.ext4 ${DEVICE}4

# mount the partitions
mkdir -p /mnt
mount ${DEVICE}2 /mnt
mkdir -p /mnt/boot
mkdir -p /mnt/home
mount ${DEVICE}1 /mnt/boot
mount ${DEVICE}4 /mnt/home

# install the base system
pacstrap /mnt base base-devel
