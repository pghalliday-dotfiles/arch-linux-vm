#!/bin/bash

set -e

DEFAULT_DEVICE=/dev/sda2

DEVICE=$1
if [ -z "$DEVICE" ]; then
  DEVICE=$DEFAULT_DEVICE
fi

# Generate the locale
sed -i '/^#en_US.UTF-8 UTF-8$/s/^#//' /etc/locale.gen
locale-gen

# Set the locale
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set the time zone and adjust the hardware clock
ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
hwclock --systohc --utc

# install the bootloader and add a boot entry
bootctl install
cat > /boot/EFI/loader/entries/arch.conf <<EOF
title          Arch Linux
linux          /vmlinuz-linux
initrd         /initramfs-linux.img
options        root=PARTUUID=$(blkid -s PARTUUID -o value $DEVICE) rw
EOF

# set the host name
echo "arch-linux" > /etc/hostname

