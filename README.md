# arch-linux-vm

Scripts to speed up set up of Arch Linux in a VirtualBox VM

## Usage

- Download the Arch Linux dual ISO - https://www.archlinux.org/download/
- Create a new VM in VirtualBox
  - We will be creating the following partition table so ensure that the disk is a sensible size (> 30GB)

    ```
    sda1 - EFI boot partition - 500MB
    sda2 - primary / partition - 20GB
    sda3 - swap partition - 4GB
    sda4 - primary /home partition - The rest
    ```

  - Open the VM settings and under `System`, check `Enable EFI (special OSes only)`
- Boot the VM from the downloaded ISO
  - This may take a couple of minutes to start and look like it has hung - **be patient**
- Download and untar the repo

  ```
  wget https://github.com/pghalliday-dotfiles/arch-linux-vm/archive/master.tgz
  tar -zxf arch-linux-vm-master.tar.gz
  cd arch-linux-vm-master
  ```

- Run the `base-install.sh` script

  ```
  ./base-install.sh
  ```

- Run the `chroot-configure.sh` script

  ```
  ./chroot-configure.sh
  ```
