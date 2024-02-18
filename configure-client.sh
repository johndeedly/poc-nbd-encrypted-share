#!/usr/bin/env bash

pacman -S --needed --noconfirm nbd

mkdir -p /etc
cp ./etc/nbdtab /etc/

mkdir -p /etc/systemd/system
cp ./etc/systemd/system/shared-decrypt.service /etc/systemd/system/
cp ./etc/systemd/system/shared.mount /etc/systemd/system/
cp ./etc/systemd/system/shared.automount /etc/systemd/system/
cp ./etc/systemd/system/shared-unmount.service /etc/systemd/system/

systemctl enable shared-unmount.service shared.automount
