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

# Generate the locale
sed -i '/^#en_US\.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen

# Set the locale
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set the time zone and adjust the hardware clock
ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
hwclock --systohc --utc

# install the bootloader and add a boot entry
bootctl install
cat > /boot/loader/entries/arch.conf <<EOF
title          Arch Linux
linux          /vmlinuz-linux
initrd         /initramfs-linux.img
options        root=PARTUUID=$(blkid -s PARTUUID -o value $DEVICE) rw
EOF

# set the host name
echo "$HOSTNAME" > /etc/hostname
sed -i "/\\slocalhost$/s/$/ $HOSTNAME/" /etc/hosts

# enable dhcp on the network interface
systemctl enable dhcpcd@enp0s3.service

# install and enable the VirtualBox Guest Utils
pacman -S --noconfirm virtualbox-guest-utils
pacman -S --noconfirm linux-headers
systemctl enable vboxservice.service
cat > /etc/modules-load.d/virtualbox.conf <<EOF
vboxguest
vboxsf
vboxvideo
EOF
# allow users to access shared folders mounted under /media
mkdir -p /media
chmod 0755 /media

# disable the root password
passwd -dl root

# create a non root user and add to sudoers (will prompt for input)
pacman -S --noconfirm sudo
echo
echo "Enter a user name:"
read USERNAME
if [ ! id -u "$USERNAME" ]; then
  useradd -m "$USERNAME"
fi
usermod -a -G vboxsf -s /bin/bash
echo
echo "Set the password for $USERNAME:"
passwd $USERNAME
echo "$USERNAME ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME
