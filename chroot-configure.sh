#!/bin/bash

set -e

curl -s https://raw.githubusercontent.com/pghalliday-dotfiles/arch-linux-vm/master/configure.sh > /mnt/configure.sh
chmod +x /mnt/configure.sh
arch-chroot /mnt configure.sh
