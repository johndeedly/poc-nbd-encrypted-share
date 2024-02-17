#!/usr/bin/env bash

pacman -S --needed --noconfirm nbd

groupadd --system nbdwrite
useradd --system -g nbdwrite nbdwrite

mkdir -p /etc/nbd-server
cp ./etc/nbd-server/config /etc/nbd-server/

mkdir -p /etc/udev/rules.d
cp ./etc/udev/rules.d/60-sdb.rules /etc/udev/rules.d/

systemctl enable nbd.service
