#!/usr/bin/env bash

pacman -S --needed --noconfirm nbd

# connect to the shared nbd drive
nbd-client '10.0.0.42' -N shareddrive -systemd-mark -persist nbd0

# create partition table with one large partition
parted -s -a optimal -- /dev/nbd0 \
    mklabel gpt \
    mkpart shared btrfs 4MiB '-4MiB'

# wait 5 seconds to let the os detect the new partition
sleep 5

# create random crypt key
openssl rand -base64 256 > ./luks.nbd.key

# encrypt and unlock
cat ./luks.nbd.key | (cryptsetup -q -v luksFormat /dev/nbd0p1 -d -)
cat ./luks.nbd.key | (cryptsetup -q open /dev/nbd0p1 shared -d -)

# format partition with btrfs
dd if=/dev/zero of=/dev/mapper/shared bs=1M count=16 iflag=fullblock status=progress
mkfs.btrfs -L SHARED /dev/mapper/shared

# sync everything
sync

# close the crypted share
cryptsetup -q close shared

# disconnect the nbd share
nbd-client -d nbd0
